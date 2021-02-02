import 'package:eventklip/screens/shared_preferences.dart';
import 'package:dio/dio.dart';

class ApiHelper {
  Future<Map<String, String>> getDefaultHeader({authenticate: false}) async {
    var defaultHeader = {'Content-Type': 'application/json; charset=UTF-8'};
    if (authenticate) {
      final token = await SharedPreferenceHelper.getToken();
      defaultHeader["Authorization"] = "Bearer $token";
    }
    return defaultHeader;
  }

  dynamic returnResponse<T>(Response<dynamic> response,
      {Function modelCreator}) {
    var responseJson = response.data;
    if (modelCreator == null) {
      return null;
    }
    if (responseJson is List) {
      var items = <T>[];
      for (var item in responseJson) {
        items.add(modelCreator(item));
      }
      return items;
    } else {
      return modelCreator(responseJson);
    }
  }
}
