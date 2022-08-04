import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketManager {
  static final SocketManager _socketManager = SocketManager._internal();

  factory SocketManager() {
    return _socketManager;
  }

  SocketManager._internal();

  io.Socket socket = io.io(AppStrings.baseUrl, <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
    "forceNew": true,
  }).connect();

  void connect() {
    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void dispose() {
    socket.dispose();
  }

  void onConnect(dynamic Function(dynamic) handler) {
    socket.onConnect(handler);
  }

  void onDisconnect(dynamic Function(dynamic) handler) {
    socket.onDisconnect(handler);
  }

  void onJoinRoom(dynamic Function(dynamic) handler) {
    socket.on("userJoined", handler);
  }

  void onLeftRoom(dynamic Function(dynamic) handler) {
    socket.on("userLeft", handler);
  }

  void onOnline(dynamic Function(dynamic) handler) {
    socket.on("online", handler);
  }

  void onTyping(dynamic Function(dynamic) handler) {
    socket.on("typing", handler);
  }

  void onDBChat(dynamic Function(dynamic) handler) {
    socket.once("getChat", handler);
  }

  void onMessage(dynamic Function(dynamic) handler) {
    socket.on("message", handler);
  }

  void sendMessage(dynamic data) {
    socket.emit("sendMessage", data);
  }

  void emitTyping(dynamic data) {
    socket.emit("typing", data);
  }

  void removeAllListeners() {
    socket.clearListeners();
  }

  void joinRoom({required int userId, required int assignmentId}) {
    socket.emit("join", {
      "user_id": userId,
      "assignment_id": assignmentId,
    });
  }
}
