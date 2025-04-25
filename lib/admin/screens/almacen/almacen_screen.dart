import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:logistika/admin/model/model.dart';
import 'package:logistika/widgets/widgets.dart';
import 'package:logistika/admin/screens/screens.dart';
import 'package:logistika/api_connection/api_connection.dart';
import 'package:logistika/admin/controllers/controllers.dart';



class AlmacenScreen extends StatefulWidget {
  AlmacenScreen({super.key});

  @override
  State<AlmacenScreen> createState() => _AlmacenScreenState();
}

class _AlmacenScreenState extends State<AlmacenScreen> {

  // final currentOnlineAdmin = Get.put(CurrentAdmin());//current Admin
  final almacenListController = Get.put(AlmacenListController());//almacen controller

  //controller for search
  TextEditingController searchController = TextEditingController();

  //add item to order cart -----------------------------------------------------


  //get all items from server --------------------------------------------------
  Future<List<Almacen>> getAllItems() async {
    List<Almacen> allItemsList = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.getAllItems)
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfAllItems = jsonDecode(res.body);
        if(responseBodyOfAllItems["success"] == true)
        {
          (responseBodyOfAllItems["itemsData"] as List).forEach((eachRecord)
          {
            allItemsList.add(Almacen.fromJson(eachRecord));
          });
        }
        almacenListController.setList(allItemsList);
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }

    return allItemsList;
  }

  //get repo items from server -------------------------------------------------
  Future<List<Almacen>> getRepoItems() async {
    List<Almacen> repoItemsList = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.getRepoItems)
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfTrending = jsonDecode(res.body);
        if(responseBodyOfTrending["success"] == true)
        {
          (responseBodyOfTrending["itemsData"] as List).forEach((eachRecord)
          {
            repoItemsList.add(Almacen.fromJson(eachRecord));
          });
        }
        almacenListController.setRepo(repoItemsList);
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }

    return repoItemsList;
  }

//------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    getAllItems();
    getRepoItems();
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    getAllItems();
    getRepoItems();
    final Color color = Color(0xFFFFFFFF);
    Size size =  MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        //automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          "Productos",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(AddNewProduct());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),

            //search bar widget
            //showSearchBarWidget(),
            const SizedBox(height: 20,),

            //all items
            Obx(()=>
            almacenListController.almacenList.length > 0
                ? SizedBox(
                child: FutureBuilder(
                  future: getAllItems(),
                  builder: (context, AsyncSnapshot<List<Almacen>> dataSnapShot)
                  {
                    // if(dataSnapShot.connectionState == ConnectionState.waiting)
                    // {
                    //   return const Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    // }
                    if(dataSnapShot.data == null)
                    {
                      return const Center(
                        child: Text(
                          "No items found",
                        ),
                      );
                    }
                    if(dataSnapShot.data!.length > 0)
                    {
                      return SizedBox(
                        height: size.height*0.45,
                        child: ListView.builder(
                          itemCount: dataSnapShot.data!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index)
                          {
                            Almacen eachItemData = dataSnapShot.data![index];
                            return GestureDetector(
                              onTap: ()
                              {
                                //go2DetailScreen
                                //Get.to(ItemDetailsScreen(itemInfo: eachClothItemData));
                              },
                              child: Container(
                                width: size.width*0.55,
                                margin: EdgeInsets.fromLTRB(
                                  index == 0 ? 16 : 8,
                                  10,
                                  index == dataSnapShot.data!.length - 1 ? 16 : 8,
                                  10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.white,
                                  boxShadow:
                                  const [
                                    BoxShadow(
                                      offset: Offset(0,3),
                                      blurRadius: 6,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20,),
                                    //image
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //image
                                        FadeInImage(
                                          width: 140,
                                          height: 140,
                                          placeholder: const AssetImage("assets/no-image.jpg"),
                                          image: NetworkImage(
                                            API.hostImagesProducts + eachItemData.image!,
                                          ),
                                        ),
                                        // //image
                                        // Image.network(
                                        //   'https://i.ibb.co/F0s3FHQ/Apricots.png',
                                        //   // width: size.width*0.22,
                                        //   //height: size.width * 0.22,
                                        //   width: 140,
                                        //   height: 140,
                                        //   fit: BoxFit.fill,
                                        // ),
                                        Column(
                                          children: [
                                            const SizedBox(height: 5,),
                                            //ventas x visita
                                            // GestureDetector(
                                            //   onTap: () {},
                                            //   child: SizedBox(
                                            //     width: 40,
                                            //     height: 40,
                                            //     child: Image.asset(
                                            //       "images/locationsale.jpg",
                                            //     ),
                                            //   ),
                                            // ),
                                            const SizedBox(height: 20,),
                                            TextWidget(
                                              text: eachItemData.codigo!,
                                              color: Colors.black,
                                              textSize: 18,
                                              isTitle: true,
                                            ),
                                            const SizedBox(height: 10,),
                                            //qtty & unit
                                            Row(
                                              children: [
                                                //qtty
                                                TextWidget(
                                                  text: eachItemData.finale!.toString(),
                                                  color: Colors.deepOrange,
                                                  textSize: 26,
                                                  isTitle: true,
                                                ),
                                                //unidad
                                                // TextWidget(
                                                //   text: eachItemData.unidad!,//text: '1.59\$',
                                                //   color: Colors.deepOrange,
                                                //   textSize: 18,
                                                //   isTitle: true,
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    //name
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextWidget(
                                              text: eachItemData.producto!,
                                              color: Colors.black,
                                              textSize: 22,
                                              isTitle: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    //Costo y variacion %
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(30, 5, 10, 5),
                                      child: Row(
                                        children: [
                                          //Costo:
                                          TextWidget(
                                            text: 'Costo: ',
                                            textSize: 18,
                                            color: Colors.redAccent,
                                          ),
                                          //costo
                                          TextWidget(
                                            text: eachItemData.costo!.toString(),
                                            textSize: 22,
                                            color: Colors.redAccent,
                                          ),
                                          //const SizedBox(width: 15,),
                                          const Spacer(),
                                          //variacion
                                          TextWidget(
                                            text: eachItemData.variacion!.toString(),
                                            textSize: 22,
                                            color: Colors.blue,
                                          ),
                                          //%
                                          TextWidget(
                                            text: ' %',
                                            textSize: 18,
                                            color: Colors.blue,
                                          ),
                                          //aumento
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    //Price
                                    Center(
                                      child: FittedBox(
                                        child: Row(
                                          children: [
                                            //pvpa txt
                                            TextWidget(
                                              text: 'PVPA: ',
                                              color: Colors.green,
                                              textSize: 18,
                                              isTitle: true,
                                            ),
                                            //pvpa
                                            TextWidget(
                                              text: eachItemData.pvpa!.toString(),
                                              color: Colors.green,
                                              textSize: 28,
                                              isTitle: true,
                                            ),
                                            const SizedBox(width: 25,),
                                            //const Spacer(),
                                            Text(
                                              eachItemData.pvpb!.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: color,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            )
                                          ],
                                        ),

                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    //edit & cart btn
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(30, 5, 10, 5),
                                      child: Row(
                                        children: [
                                          //edit
                                          GestureDetector(
                                            onTap: () {
                                              // Get.to(EditAlmacen(clickedAlmacenInfo: eachItemData,));
                                            },
                                            child: SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: Image.asset(
                                                "assets/images/edit.png",
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          //cart
                                          GestureDetector(
                                            onTap: () {
                                              // add item to order cart
                                              // addItemToOrderCart(eachItemData.almacen_id!);
                                            },
                                            child: SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: Image.asset(
                                                "assets/images/cart1.jpeg",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2,),

                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    else
                    {
                      return Center(
                        child: TextWidget(
                          text: ' Empty, No Data. ',
                          textSize: 20,
                          color: Colors.indigo,
                        ),
                      );
                    }
                  },
                )
            )
                : Center(
              child: TextWidget(
                text: ' No existe registro de Productos! ',
                textSize: 20,
                color: Colors.brown,
              ),
            ),
            ),
            const SizedBox(height: 20,),

            //onReposition
            Obx(()=>
            almacenListController.repoList.length > 0
                ? Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      TextWidget(
                        text: 'REPOSICIONES!'.toUpperCase(),
                        color: Colors.brown,
                        textSize: 22,
                        isTitle: true,
                      )
                    ],
                  ),
                ),
                repoItemWidget(context),
              ],
            )
                : Center(
              child: TextWidget(
                text: '    Empty, No Repos!',
                textSize: 20,
                color: Colors.brown,
              ),
            ),
            ),

            //const SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }

//------------------------------------------------------------------------------


  //search item ----------------------------------------------------------------
  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: ()
            {
              //Keyboard unfocus!!
              FocusScope.of(context).unfocus();
              Get.back();
              //Get.to(SearchItems(typedKeyWords: searchController.text));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.brown,
            ),
          ),
          // hintText: "Search your stock items here...",
          hintText: "Busca tus productos en Almacen Aqui!...",
          hintStyle: const TextStyle(
            color: Colors.black,//grey,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: ()
            {
              //Keyboard unfocus!!
              FocusScope.of(context).unfocus();
              Get.back();
              //Get.to(CartListScreen());
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.brown,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.brown,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.brown,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  //get reposition item --------------------------------------------------------
  repoItemWidget(context) {
    // final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final Color color = Color(0xFFFFFFFF);
    Size size =  MediaQuery.of(context).size;
    return FutureBuilder(
      future: getRepoItems(),
      builder: (context, AsyncSnapshot<List<Almacen>> dataSnapShot)
      {
        // if(dataSnapShot.connectionState == ConnectionState.waiting)
        // {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        if(dataSnapShot.data == null)
        {
          return const Center(
            child: Text(
              "No items found",
            ),
          );
        }
        if(dataSnapShot.data!.length > 0)
        {
          return SizedBox(
            height: size.height*0.25,
            width: size.width*0.90,
            child: ListView.builder(
                itemCount: dataSnapShot.data!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  Almacen eachItemData = dataSnapShot.data![index];
                  //------------------------------------------------------
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.brown.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10,),
                                    //image
                                    FadeInImage(
                                      width: size.width*0.22,
                                      height: size.width * 0.22,
                                      placeholder: const AssetImage("assets/no-image.jpg"),
                                      image: NetworkImage(
                                        API.hostImagesProducts + eachItemData.image!,
                                      ),
                                    ),
                                    // Image.network(
                                    //   'https://i.ibb.co/F0s3FHQ/Apricots.png',
                                    //   //width: size.width*0.22,
                                    //   height: size.width * 0.22,
                                    //   fit: BoxFit.fill,
                                    // ),
                                    Column(
                                      children: [
                                        const SizedBox(height: 10,),
                                        //to order cart
                                        GestureDetector(
                                          onTap: () {
                                            // add item to order cart
                                            // addItemToOrderCart(eachItemData.almacen_id!);
                                          },
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                              "assets/images/pedidos.png",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6,),
                                        //cost price
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            TextWidget(
                                              text: 'Bs.',
                                              color: color,
                                              textSize: 20,
                                            ),
                                            const SizedBox(width: 6,),
                                            TextWidget(
                                              text: eachItemData.costo!.toString(),
                                              color: color,
                                              textSize: 20,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6,),
                                        //qtty & unit
                                        Row(
                                          children: [
                                            TextWidget(
                                              text: eachItemData.finale!.toString(),
                                              color: Colors.red,
                                              textSize: 24,
                                              isTitle: true,
                                            ),
                                            TextWidget(
                                              text: eachItemData.unidad!,
                                              color: color,
                                              textSize: 18,
                                              isTitle: true,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6,),
                                      ],
                                    )
                                  ],
                                ),
                                //const PriceWidget(),
                                const SizedBox(height: 10),
                                TextWidget(text: eachItemData.producto!, color: color, textSize: 16, isTitle: true,),
                                //const SizedBox(height: 5),
                              ]
                          ),
                        ),
                      ),
                    ),
                  );
                  //------------------------------------------------------
                }
            ),
          );
        }
        else
        {
          return Center(
            //child: Text("       Empty, No Data."),
            child: TextWidget(
              text: '    Empty, No Repos!',
              textSize: 20,
              color: Colors.indigo,
            ),
          );
        }
      },
    );
  }

}

