import 'dart:convert';

class JsonMessageHandler {
  String jsonConvert(jsonObject) {
    var deserialisedData = jsonDecode(jsonObject);
    // TODO: Tidy and implement DRY principles.
    if (deserialisedData['type'] == 'join') {
      return deserialisedData['value'];
    } else if (deserialisedData['type'] == 'leave') {
      return deserialisedData['value'];
    } else if (deserialisedData['type'] == 'name') {
      // TODO: Implement this.
      return '${deserialisedData['value']} has changed their name to ${deserialisedData['value1']}';
    } else if (deserialisedData['type'] == 'message') {
      // Default action is to return the chat messages.
      return deserialisedData['value'];
      // TODO: Create a message for reconnection event with cookie/session.
    } else {
      return 'There is an issue.';
    }
  }
}
