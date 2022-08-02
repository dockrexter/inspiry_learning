import 'package:flutter/cupertino.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/models/message_model.dart';
import 'package:inspiry_learning/manager/socket_manager.dart';

class ChatProvider with ChangeNotifier {
  final int assignmentId;
  final _socket = SocketManager();
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  ChatProvider({required this.assignmentId}) {
    _socket.connect();
    _socket.joinRoom(
        userId: ActiveUser.instance.user!.userId!, assignmentId: assignmentId);
    _socket.onDBChat((data) {
      if (data["status"] == "ok") {
        for (var message in data["data"]) {
          _addMessage(Message.fromJson(message));
        }
      }
    });
    _socket.onMessage((data) {
      _addMessage(Message.fromJson(data));
      if (data["message"] != null) {
        Utils.showNotification(title: "New Message", body: data["message"]);
      }
    });
  }

  void sendMessage(Message message) {
    _socket.sendMessage(message.toJson());
    _addMessage(message);
  }

  void _addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void removeMessage(Message message) {
    _messages.remove(message);
    notifyListeners();
  }

  void updateMessage(Message message) {
    _messages.removeWhere((m) => m.id == message.id);
    _messages.add(message);
    notifyListeners();
  }

  void removeAllListeners() {
    _socket.removeAllListeners();
  }

  void disconnect() {
    _socket.disconnect();
  }
}
