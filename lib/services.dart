import 'package:http/http.dart' as http;
import 'catogoryclass.dart';

class Services{

  static Future<List<AllCategory>?> getCategori(int paraentid,int flag) async {
    final response = await http.get(Uri.parse(flag == 1 ? 'http://testclt70.posibolt.org/AdempiereService/PosiboltRest/productcategorylist/?parentOnly=true'
        : 'http://testclt70.posibolt.org/AdempiereService/PosiboltRest/productcategorylist/${paraentid}?parentOnly=true' )
        , headers: { "Accept": "application/json",
          "Authorization": 'Bearer ab2dc9f6-681a-42fc-967c-86583e447251'});
    print("the responce${response.body}");
    if (response.statusCode == 200) {
      print("the response${response.body}");
      return allCategoryFromJson(response.body);
    } else {
      return null;
    }
  }

}