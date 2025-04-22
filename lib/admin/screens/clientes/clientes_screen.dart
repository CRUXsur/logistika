//------------------------------------------------------------------------------




import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:logistika/widgets/widgets.dart';
import 'package:logistika/admin/model/model.dart';
import 'package:logistika/admin/screens/screens.dart';
import 'package:logistika/api_connection/api_connection.dart';
import 'package:logistika/admin/controllers/controllers.dart';


class ClientesScreen extends StatefulWidget {
  ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {

  // final currentOnlineAdmin = Get.put(CurrentAdmin());//current Admin
  final clientListController = Get.put(ClientListController());//client controller

  //controller for search
  TextEditingController searchController = TextEditingController();


//------------------------------------------------------------------------------
  //Get all clientes
  Future<List<Clientes>> getAllClients() async {
    List<Clientes> allClientesList = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.getAllClient)
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfAllItems = jsonDecode(res.body);
        if(responseBodyOfAllItems["success"] == true)
        {
          (responseBodyOfAllItems["clientesData"] as List).forEach((eachRecord)
          {
            allClientesList.add(Clientes.fromJson(eachRecord));
          });
        }
        clientListController.setList(allClientesList);
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

    return allClientesList;
  }
//------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    getAllClients();
  }

  @override
  Widget build(BuildContext context) {
    getAllClients();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        //automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          "Clientes",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(AddNewClient());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Obx(()=>
            clientListController.clientList.length > 0
                ? SizedBox(

                child: FutureBuilder(
                  future: getAllClients(),
                  builder: (context, AsyncSnapshot<List<Clientes>> dataSnapShot)
                  {
                    //print(dataSnapShot.data!.length);
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
                      List<Clientes> clientList = dataSnapShot.data!;
                      return SizedBox(
                        //height: 500,
                        child: ListView.separated(
                          itemCount: clientList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          separatorBuilder: (context,index) => const Divider(
                            thickness: 1,
                            height: 1,
                            color: Colors.indigoAccent,
                          ),
                          itemBuilder: (context, index){
                            Clientes eachClientData = clientList[index];
                            //------------------------------------------------------
                            return Slidable(
                              //Nueva Venta & Nueva Cotizacion
                              startActionPane: ActionPane(
                                motion: const BehindMotion(),
                                children: [
                                  // Nueva Venta
                                  SlidableAction(
                                    icon: Icons.monetization_on,
                                    onPressed: (context) {
                                      //
                                      //Get.to(NuevaVenta(clickedClienteInfo: eachClientData,));
                                      // Get.to(CartListScreen(clickedClienteInfo: eachClientData,));
                                    },
                                    backgroundColor: Colors.pink,
                                    label: "VENTA",
                                  ),
                                  //Nueva Cotizacion
                                  SlidableAction(
                                    icon: Icons.request_quote,
                                    onPressed: (context) {
                                      // Get.to(CotListScreen(clickedClienteInfo: eachClientData,));
                                    },
                                    backgroundColor: Colors.amber,
                                    label: "COTIZACION",
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const BehindMotion(),
                                children: [
                                  SlidableAction(
                                    icon: Icons.draw,
                                    onPressed: (context) {
                                      // Get.to(EditClient(clickedClienteEdit: eachClientData,));
                                    },
                                    backgroundColor: Colors.grey,
                                    label: "EDIT",
                                  ),
                                  // SlidableAction(
                                  //   icon: Icons.delete,
                                  //   onPressed: (context) {},
                                  //   backgroundColor: Colors.redAccent,
                                  //   label: "DELETE",
                                  // ),
                                ],
                              ),
                              child: ListTile(
                                leading: SizedBox(
                                  width: 60,
                                  child: Image.network(API.hostImagesClients + eachClientData.image!),
                                ),
                                //title
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      eachClientData.negocio!.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      eachClientData.contacto!.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    //Razon Social y Nit
                                    Text(
                                      "${eachClientData.razonSocial!}-${eachClientData.nit!}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                //trailing
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      eachClientData.movil!.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Bs. " + eachClientData.totalCompra!.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            //------------------------------------------------------
                          },
                        ),
                      );
                    }
                    else
                    {
                      return Center(
                        child: TextWidget(
                          text: ' No existe registro de Clientes! ',
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
                text: ' No existe registro de Clientes! ',
                textSize: 20,
                color: Colors.indigo,
              ),
            ),
            ),

          ],
        ),
      ),
    );
  }



//------------------------------------------------------------------------------
  //search bar
  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        style: const TextStyle(color: Colors.indigo),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: ()
            {
              //Keyboard unfocus!!
              FocusScope.of(context).unfocus();
              //Get.to(SearchItems(typedKeyWords: searchController.text));
              setState(() {
              });
            },
            icon: const Icon(
              Icons.search,
              color: Colors.indigo,
            ),
          ),
          hintText: "Search your client here...",
          hintStyle: const TextStyle(
            color: Colors.indigo,//grey,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: ()
            {
              searchController.clear();

              setState(() {
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.indigo,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.indigo,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.indigo,
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
//------------------------------------------------------------------------------

}
