import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens.dart';



class ClientesScreen extends StatelessWidget {
  ClientesScreen({super.key});

  //controller for search
  TextEditingController searchController = TextEditingController();



  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 20,),

            //search bar widget
            showSearchBarWidget(),
            const SizedBox(height: 30,),
            //all clientes

            const SizedBox(height: 30,),
            //Add new cliente button

          ],
        ),
      ),
    );
  }

  //------------------------------------------------------------


  //search bar
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
              //Get.to(SearchItems(typedKeyWords: searchController.text));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.indigo,
            ),
          ),
          hintText: "Busca to cliente aqui...",
          hintStyle: const TextStyle(
            color: Colors.indigo,//grey,
            fontSize: 14,
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





}
