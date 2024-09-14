import 'package:assan_khata_frontend/core/common/notification_service.dart';
import 'package:assan_khata_frontend/core/secrets/app_secrets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  IO.Socket? _socket;
  String? _userId;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  void initializeSocket(String userId) {
    if (_socket != null && _socket!.connected) {
      print("Socket is already connected for user: $_userId");
      return;
    }

    _userId = userId;
    _socket = IO.io(
      AppSecrets().baseServerUrl(),
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.on('connect', (_) {
      print('Connected to socket server');
      _socket!.emit('join', _userId); // Add user to the room
    });

    _socket!.on('disconnect', (_) {
      print('Disconnected from socket server');
      _socket!.emit('leave', _userId); // Remove user from the room
    });

    _socket!.on('connect_error', (error) {
      print('Connection error: $error');
    });

    _socket!.on('error', (error) {
      print('Socket error: $error');
    });

    _socket!.on('newNotification', (data) {
      final title = data['title'];
      final body = data['body'];
      if (title != null && body != null) {
        showNotification(title, body);
      }
    });

    _socket!.connect();
  }

  void disconnectSocket() {
    if (_socket != null) {
      _socket!.emit('leave', _userId); // Explicitly remove the user on logout
      _socket!.disconnect();
      _socket = null; // Reset socket so it can be re-initialized
    }
  }

  void reconnectSocket(String userId) {
    if (_socket == null || !_socket!.connected) {
      initializeSocket(userId);
      _socket!.connect();
    } else {
      _socket!.emit('join', userId); // Re-add user to the room if connected
    }
  }

  IO.Socket? get socket => _socket;
}
