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
        }).connect();

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

  void onDisconnect(dynamic Function(dynamic) handler) {
    _socket.onDisconnect(handler);
  }

  void onJoinRoom(dynamic Function(dynamic) handler) {
    _socket.on("userJoined", handler);
  }

  void onLeftRoom(dynamic Function(dynamic) handler) {
    _socket.on("userLeft", handler);
  }

  void onOnline(dynamic Function(dynamic) handler) {
    _socket.on("online", handler);
  }

  void onTyping(dynamic Function(dynamic) handler) {
    _socket.on("typing", handler);
  }

  void onDBChat(dynamic Function(dynamic) handler) {
    _socket.once("getChat", handler);
  }

  void onMessage(dynamic Function(dynamic) handler) {
    _socket.on("message", handler);
  }

  void sendMessage(dynamic data) {
    _socket.emit("sendMessage", data);
  }

  void emitTyping(dynamic data) {
    _socket.emit("typing", data);
  }

  void removeAllListeners() {
    _socket.clearListeners();
  }

  void joinRoom({required int userId, required int assignmentId}) {
    _socket.emit("join", {
      "user_id": userId,
      "assignment_id": assignmentId,
    });
  }
}
