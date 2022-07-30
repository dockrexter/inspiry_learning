import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketManager {
  static final SocketManager _socketManager = SocketManager._internal();

  factory SocketManager() {
    return _socketManager;
  }

  SocketManager._internal()
      : _socket = io.io(AppStrings.baseUrl, {
          "transports": ["websocket"],
          "autoConnect": false,
        }) {
    _socket.connect();
  }

  final io.Socket _socket;

  void connect() {
    _socket.connect();
  }

  void disconnect() {
    _socket.disconnect();
  }

  void dispose() {
    _socket.dispose();
  }

  void onConnect(dynamic Function(dynamic) handler) {
    _socket.onConnect(handler);
  }

  void onMessage(dynamic Function(dynamic) handler) {
    _socket.on("message", handler);
  }

  void sendMessage(dynamic data) {
    _socket.emit("sendMessage", data);
  }

  void emitJoinEvent({required int userId, required int assignmentId}) {
    _socket.emit("join", {
      "user_id": userId.toString(),
      "assignment_id": assignmentId.toString(),
    });
  }
}
