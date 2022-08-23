import 'package:category/secondscreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Categorys',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  SecondScreen(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AllCategory> listParentCategory = [];
  List<SubCategory> listChildCategory = [];
  List<AllCategory> listSelectedCategory = [];
  int childListCount = 0;
  int categoryListCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategori(0, 1).then((value){
      listParentCategory = value!;
      setState(() {
        categoryListCount = listParentCategory.length;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Category"),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              /** Category List **/
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context,int index){
                    return Padding(padding: const EdgeInsets.all(8),
                      child: InkWell(
                        child: Container(
                          color: Colors.green,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(listParentCategory[index].name,style: const TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                        onTap: (){
                          getCategori(listParentCategory[index].productCategoryId, 0).then((value){
                            setState(() {
                              listChildCategory.clear();
                              listSelectedCategory.clear();
                              selectCategoryItem(listParentCategory[index]);
                              listChildCategory.add(SubCategory(listParentCategory[index].productCategoryId,
                                  value!));
                              childListCount = listChildCategory.length;
                            });
                          });
                        },
                      ),);
                  },
                  itemCount: categoryListCount,),
              ),
              const SizedBox(height: 20,),


              /** sub category list **/
              SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext c,int i){
                    return buildChildCategory(listChildCategory[i].listCategory,i);
                  },
                  itemCount: childListCount,),
              ),
              const SizedBox(height: 35,),


              /** selected Item list **/
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context,int index){
                    return Padding(padding: const EdgeInsets.all(8),
                      child: InkWell(
                        child: Container(
                          color: Colors.green,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(listSelectedCategory[index].name,style: const TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                        onTap: (){
                          removeSelectedCategoryItem(listSelectedCategory[index].productCategoryId,index,false);
                        },
                      ),);
                  },
                  itemCount: listSelectedCategory.length,),
              ),

            ],
          ),
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }



  static Future<List<AllCategory>?> getCategori(int paraentid,int flag) async {

    final response = await http.get(Uri.parse(flag == 1 ? 'http://testclt70.posibolt.org/AdempiereService/PosiboltRest/productcategorylist/?parentOnly=true' : 'http://testclt70.posibolt.org/AdempiereService/PosiboltRest/productcategorylist/${paraentid}?parentOnly=true' )
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

  Widget buildChildCategory(List<AllCategory> listChildCategories,int ind){
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context,int index){
            return Padding(padding: const EdgeInsets.all(8),
              child:InkWell(
                child:  Container(
                  color: Colors.green,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(listChildCategories[index].name,style: const TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                onTap: (){
                  if(checkChildCategoryExist(listChildCategories[index].productCategoryId)){
                    removeSelectedCategoryItem(listChildCategories[index].parentCategoryId,index, true);
                    selectCategoryItem(listChildCategories[index]);
                    getCategori(listChildCategories[index].productCategoryId, 0).then((value){
                      setState(() {
                        removeChildCategory(ind,listChildCategories,index);
                        if(value!.isNotEmpty) {
                          listChildCategory.add(SubCategory(
                              listChildCategories[index].productCategoryId,
                              value));
                        }
                        childListCount = listChildCategory.length;

                      });
                    });
                  }
                },
              ),);
          },
          itemCount: listChildCategories.length),
    );
  }

  void removeChildCategory(int ind,List<AllCategory>listChildCategories,int index){
    for(int i = ind+1 ; i < listChildCategory.length ; i++){
      if(listChildCategory[i].parentId != listChildCategories[index].productCategoryId){
        listChildCategory.removeAt(i);
        removeChildCategory(ind, listChildCategories, i);

      }
    }
  }

  bool checkChildCategoryExist(int parentId){
    return listChildCategory.where((element) => element.parentId == parentId).toList().isEmpty;
  }

  void selectCategoryItem(AllCategory selectedItem){
    listSelectedCategory.add(selectedItem);

  }

  void removeSelectedCategoryItem(int parentId,int id ,bool isClickedFromChildCategory){
    if(!isClickedFromChildCategory) {
      listSelectedCategory.removeWhere((element) =>
      element.productCategoryId == id);
      for (int i = 0; i < listChildCategory.length; i++) {
        if (listChildCategory[i].parentId == id) {
          setState(() {
            int parentId = listChildCategory[i].listCategory[0].productCategoryId;
            int productId =  listChildCategory[i].listCategory[0].productCategoryId;
            listChildCategory.removeAt(i);
            childListCount = listChildCategory.length;
            removeSelectedCategoryItem(parentId,productId,isClickedFromChildCategory);
          });
          break;
        }
      }
    }else{
      // listSelectedCategory.removeWhere((element) => element.parentCategoryId != id);
    }
  }
}


class SubCategory{
  int parentId;
  List<AllCategory> listCategory;

  SubCategory(this.parentId, this.listCategory);
}


List<AllCategory> allCategoryFromJson(String str) => List<AllCategory>.from(json.decode(str).map((x) => AllCategory.fromJson(x)));
String allCategoryToJson(List<AllCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class AllCategory {
  AllCategory({
    required this.productCategoryId,
    required this.isActive,
    required this.name,
    required this.parentCategoryId,
  });
  int productCategoryId;
  String isActive;
  String name;
  int parentCategoryId;
  factory AllCategory.fromJson(Map<String, dynamic> json) => AllCategory(
    productCategoryId: json["productCategoryId"],
    isActive: json["isActive"],
    name: json["name"],
    parentCategoryId: json["parentCategoryId"],
  );
  Map<String, dynamic> toJson() => {
    "productCategoryId": productCategoryId,
    "isActive": isActive,
    "name": name,
    "parentCategoryId": parentCategoryId,
  };
}
