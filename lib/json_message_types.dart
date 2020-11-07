import 'dart:convert';

class JsonMessageHandler {
  String jsonConvert(jsonObject) {
    var deserialisedData = jsonDecode(jsonObject);
    if (deserialisedData['type'] == 'users') {
      return 'There are now ${deserialisedData['count']} users in this room!';
    } else if (deserialisedData['type'] == 'name') {
      return ''
    } 
    
    else {
      return deserialisedData['messages'];
    }
    
  }
}
