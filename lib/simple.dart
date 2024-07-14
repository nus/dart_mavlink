import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_mavlink/mavlink.dart';

sealed class Link {}

/// Represents a `Link` of type server.
/// The generic parameter Id must be unique for all clients.
abstract class ServerLink<Id> extends Link {
  /// **Starts a server for this link. This method will always be called once and before other methods.**<br><br>
  /// The link should call `onClientConnected` when a client is successfully connected. The parameter identifier must be unique for this client. It doesn't mean that the client is capable of receiving mavlink messages.<br><br>
  /// The link should call `onDataReceived` when data is received from a client. The parameter sourceIdentifier must be the same given to onClientConnected.<br><br>
  /// The link should call `onSendCompleted` when a call to send is completed. It should be called with the targetIdentifier and the sequence of the sent frame.
  FutureOr<void> startServer(
      {required FutureOr<void> Function(Id identifier) onClientConnected,
      required FutureOr<void> Function(Id sourceIdentifier, Uint8List data)
          onDataReceived,
      required FutureOr<void> Function(Id targetIdentifier, int frameSequence)
          onSendCompleted});

  /// Invalidates (aka disconnects) a client. No more calls to onDataReceived should be made after this function has been called until onClientConnected is called again.
  FutureOr<void> invalidateClient(Id identifier);

  /// Sends a frame to the target with the given targetIdentifier.
  /// This method only implies a request to send data has been started. It does not necessarily mean that the send operation is complete.
  FutureOr<void> send(Id targetIdentifier, MavlinkFrame frame);
}

class UdpServerLink extends ServerLink<(InternetAddress address, int port)> {
  late RawDatagramSocket socket;
  String serverAddress;
  int serverPort;
  List<(InternetAddress address, int port)> knownAddresses = [];
  ((InternetAddress address, int port), int seq)? lastSentMessage;

  UdpServerLink(this.serverAddress, this.serverPort);

  @override
  FutureOr<void> invalidateClient((InternetAddress, int) identifier) {
    knownAddresses.remove(identifier);
  }

  @override
  FutureOr<void> send(
      (InternetAddress, int) targetIdentifier, MavlinkFrame frame) {
    int result = socket.send(
        frame.serialize(), targetIdentifier.$1, targetIdentifier.$2);
    assert(result != 0);
  }

  @override
  FutureOr<void> startServer(
      {required FutureOr<void> Function((InternetAddress, int) identifier)
          onClientConnected,
      required FutureOr<void> Function(
              (InternetAddress, int) sourceIdentifier, Uint8List data)
          onDataReceived,
      required FutureOr<void> Function(
              (InternetAddress, int) targetIdentifier, int frameSequence)
          onSendCompleted}) async {
    socket = await RawDatagramSocket.bind(serverAddress, serverPort);
    socket.listen((event) {
      switch (event) {
        case RawSocketEvent.read:
          Datagram datagram = socket.receive()!;
          var id = (datagram.address, datagram.port);
          if (!knownAddresses.contains(id)) {
            onClientConnected(id);
            knownAddresses.add(id);
          }
          onDataReceived(id, datagram.data);
          break;
        case RawSocketEvent.closed:
          throw UnimplementedError(
              "The udp server socket should not be closed");
        case RawSocketEvent.write:
          if (lastSentMessage != null) {
            onSendCompleted(lastSentMessage!.$1, lastSentMessage!.$2);
          }
          break;
        default:
          throw UnsupportedError(
              "No such event exists for a RawDatagramSocket.");
      }
    });
  }
}

abstract class ClientLink extends Link {}

class _MavlinkSimpleLinkClientDetails {
  dynamic identifier;
  int? systemId;
  int? componentId;
  MavlinkParser parser;
  int seq;

  _MavlinkSimpleLinkClientDetails(
      this.identifier, this.systemId, this.componentId, this.parser, this.seq);
}

class MavlinkSimple {
  final MavlinkDialect dialect;
  final StreamController<
          (Link sourceLink, dynamic sourceIdentifier, MavlinkFrame frame)>
      _messageStreamController = StreamController.broadcast();
  Stream<(Link sourceLink, dynamic sourceIdentifier, MavlinkFrame frame)>
      get messageStream => _messageStreamController.stream;
  int systemId;
  int componentId;

  final HashMap<Link, HashMap<dynamic, _MavlinkSimpleLinkClientDetails>>
      _links = HashMap();
  Iterable<Link> get links => _links.keys;

  /// Creates a MavlinkSimple object with a given dialect.
  MavlinkSimple(this.dialect, this.systemId, this.componentId);

  /// Adds a link.
  Future<void> addLink(Link link) async {
    if (link is! ServerLink) {
      throw UnimplementedError("Client links are currently not implemented.");
    }

    _links[link] = HashMap<dynamic, _MavlinkSimpleLinkClientDetails>();

    link.startServer(onClientConnected: (id) {
      var parser = MavlinkParser(dialect);
      parser.stream.listen((frame) {
        if (_links[link]![id]!.systemId == null ||
            _links[link]![id]!.componentId == null) {
          _links[link]![id]!.systemId = frame.systemId;
          _links[link]![id]!.componentId = frame.componentId;
        }
        _messageStreamController.add((link, id, frame));
      });
      _links[link]![id] =
          _MavlinkSimpleLinkClientDetails(id, null, null, parser, 0);
    }, onDataReceived: (id, data) {
      _links[link]![id]!.parser.parse(data);
    }, onSendCompleted: (id, seq) {
      // Do nothing for now.
    });
  }

  void removeLink(Link link) {
    _links.remove(link);
  }

  void send(MavlinkMessage message) {
    if (message.hasTargetSystem != null && message.hasTargetComponent != null) {
      int targetSystem = message.hasTargetSystem!;
      int targetComponent = message.hasTargetComponent!;
      for (var entries in _links.entries) {
        if (entries.key is! ServerLink) {
          continue;
        }

        for (var clientDetails in entries.value.values) {
          if (clientDetails.systemId == targetSystem &&
              clientDetails.componentId == targetComponent) {
            (entries.key as ServerLink).send(
                clientDetails.identifier,
                MavlinkFrame.v2(
                    clientDetails.seq, systemId, componentId, message));
          }
        }
      }
    } else {
      for (var link in _links.entries) {
        if (link.key is ServerLink) {
          for (var client in link.value.entries) {
            (link.key as ServerLink).send(
                client.key,
                MavlinkFrame.v2(
                    client.value.seq, systemId, componentId, message));
          }
        }
      }
    }
  }
}
