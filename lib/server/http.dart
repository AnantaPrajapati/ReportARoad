import 'dart:convert';

import "package:http/http.dart" as http;

class RequestResult
{
  bool ok;
  dynamic data;
  RequestResult(this.ok, this.data);
}

const protocol = "http";
const domain = "192.168.0.101:9000";

Future<RequestResult> httpGet(String route, [dynamic data]) async
{
  var dataStr = jsonEncode(data);
  var url = "$protocol://$domain/$route?data=$dataStr";
  var result = await http.get(url as Uri);
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> httPost(String route, [dynamic data]) async
{
  var url = "$protocol://$domain/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url as Uri, body: dataStr, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}



//  createUser() async {
//     var result = await http_post("create-user", {
//       "name": nameController.text,
//     });
//     if(result.ok)
//     {
//       setState(() {
//         response = result.data['status'];
//       });
//     }
//   }