import 'package:web_socket_channel/web_socket_channel.dart';

main(List<String> args) {
  WebSocketChannel socket =
      WebSocketChannel.connect(Uri.parse('ws://localhost:5505'));
  while (true) {
    print(socket.stream.toString());
  }
}
