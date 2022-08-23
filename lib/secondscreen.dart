import 'package:category/catogoryclass.dart';
import 'package:category/services.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
    List<AllCategory> allcategoryList = [];
    List<SubCategory> categoryList = [];
    List<SubCategory> subcategoryList = [];
    List<AllCategory> listSelectedCategory = [];
    List<SelectedItem> selectedItemList = [];

    int level = 0;
    int childListCount = 0;


    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Services.getCategori(0, 1).then((value) {
      setState(() {
        allcategoryList = value!;
        categoryList.add(SubCategory(0, 0, value));
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minto Category Test"),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            categoryList.length == 0 ? Container():
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context,int index){
                  return Padding(padding: const EdgeInsets.all(8),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: categoryList[0].listCategory[index].isChecked == true ? Colors.green : Colors.white ,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(width: 2, color: Colors.black),),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(categoryList[0].listCategory[index].name,style: const TextStyle(color: Colors.black),),
                          ),
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          listSelectedCategory.clear();
                          selectedItemList.clear();
                          isCheackfalsing(categoryList[0].listCategory);
                          categoryList[0].listCategory[index].isChecked = true;
                          selectedItemList.add(SelectedItem(categoryList[0].level, categoryList[0].listCategory[index].productCategoryId, categoryList[0].parentId, index, categoryList[0].listCategory[index].name));

                          Services.getCategori(categoryList[0].listCategory[index].productCategoryId, 0).then((value){
                              subcategoryList.clear();
                              //removeChildCategory(ind,listChildCategories,index);

                               setState(() {
                                 if(value!.isNotEmpty) {
                                   selectCategoryItem(categoryList[0].listCategory[index]);
                                   subcategoryList.add(SubCategory(categoryList[0].listCategory[index].productCategoryId, categoryList[0].level+1 ,value));
                                   childListCount = subcategoryList.length;
                                 }

                               });
                            
                          });

                        });
                      },
                    ),);
                },
                itemCount: categoryList[0].listCategory.length,),
            ),

            SizedBox(height: 25,),
            subcategoryList.length == 0 ? Container():SizedBox(
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (BuildContext c,int i){
                  return buildChildCategory(subcategoryList[i].listCategory,i,subcategoryList[i].level,subcategoryList[i].parentId);
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
                        color: Colors.red,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(selectedItemList[index].name,style: const TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                      onTap: (){
                       // removeSelectedCategoryItem(listSelectedCategory[index].productCategoryId,index,false);
                      },
                    ),);
                },
                itemCount: selectedItemList.length,),
            ),



          ],
        ),
      ),
    );
  }

  void isCheackfalsing(List<AllCategory> categoryList){
      for(int i = 0 ; i < categoryList.length ; i++){
        categoryList[i].isChecked = false;
      }
  }

  Widget buildChildCategory(List<AllCategory> listCategory, int i,int level,int parentId) {
      return SizedBox(
        height: 80,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context,int index){
              return Padding(padding: const EdgeInsets.all(8),
                child:InkWell(
                  child:  Container(
                    decoration: BoxDecoration(
                      color: subcategoryList[i].listCategory[index].isChecked == true ? Colors.green : Colors.white ,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 2, color: Colors.black),),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(listCategory[index].name,style: const TextStyle(color: Colors.black),),
                      ),
                    ),
                  ),
                  onTap: (){
                    removeSelectedListData(level+1);
                    removeSelectedListData(level);
                    if(checkChildCategoryExist(listCategory[index].productCategoryId)){
                      isCheackfalsing(listCategory);
                      listCategory[index].isChecked = true;
                      removeSelectedCategoryItem(listCategory[index].productCategoryId,index, true);
                      selectCategoryItem(listCategory[index]);


                      setState(() {
                        if(selectedItemList.where((element) => element.productCategoryId == listCategory[index].productCategoryId).toList().length == 0){
                          selectedItemList.add(SelectedItem(level, listCategory[index].productCategoryId, listCategory[index].parentCategoryId, index, listCategory[index].name));
                        }
                      });

                      Services.getCategori(listCategory[index].productCategoryId, 0).then((value){
                        setState(() {
                          removeChildCategory(i,listCategory,index);
                          if(value!.isNotEmpty) {
                            subcategoryList.add(SubCategory(listCategory[index].productCategoryId, level+1, value));
                          }
                          childListCount = subcategoryList.length;
                          print(subcategoryList);
                        });
                      });
                    }

                  },
                ),);
            },
            itemCount: listCategory.length),
      );
  }

    void removeSelectedCategoryItem(int parentId,int id ,bool isClickedFromChildCategory){

        listSelectedCategory.removeWhere((element) =>
        element.productCategoryId == id);
        for (int i = 0; i < subcategoryList.length; i++) {
          if (subcategoryList[i].parentId == id) {
            setState(() {
              int parentId = subcategoryList[i].listCategory[0].productCategoryId;
              int productId =  subcategoryList[i].listCategory[0].productCategoryId;
              subcategoryList.removeAt(i);
              childListCount = subcategoryList.length;
              removeSelectedCategoryItem(parentId,productId,isClickedFromChildCategory);
            });
            break;
          }
        }
    }

    void removeChildCategory(int ind,List<AllCategory> listChildCategories,int index){
      for(int i = ind+1 ; i < subcategoryList.length ; i++){
        if(subcategoryList[i].parentId != listChildCategories[index].productCategoryId){
          subcategoryList.removeAt(i);
          removeChildCategory(ind, listChildCategories, i);
        }
      }
    }

    bool checkChildCategoryExist(int parentId){
      return subcategoryList.where((element) => element.parentId == parentId).toList().isEmpty;
    }

    void selectCategoryItem(AllCategory selectedItem){
      listSelectedCategory.add(selectedItem);
    }

    void removeSelectedListData(int level){
      for(int i = level ; i<=selectedItemList.length ; i++){
        selectedItemList.removeWhere((element) => element.levels == i);
      }
    }
}
