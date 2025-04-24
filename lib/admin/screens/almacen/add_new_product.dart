import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:logistika/admin/model/model.dart';
import 'package:logistika/api_connection/api_connection.dart';



class AddNewProduct extends StatelessWidget {
  AddNewProduct({super.key});

//controllers for add items model
  var formKey = GlobalKey<FormState>();
  var codigoController = TextEditingController();
  var productoController = TextEditingController();
  var unidadController = TextEditingController();
  var categoriaController = TextEditingController();
  var costoController = TextEditingController();
  var pvpaController = TextEditingController();
  var pvpbController = TextEditingController();

//this to declare
//vars for image to db--------------------------
  RxList<int> _imageSelectedByte = <int>[].obs;
  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);

  RxString _imageSelectedName = "".obs;
  String get imageSelectedName => _imageSelectedName.value;

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;

  // CurrentAdmin currentAdmin = Get.put(CurrentAdmin());

  setSelectedImage(Uint8List selectedImage)
  {
    _imageSelectedByte.value = selectedImage;
  }
  setSelectedImageName(String selectedImageName)
  {
    _imageSelectedName.value = selectedImageName;
  }
//----------------------------------------------

//add item Screen methods ----------------------------------------
  captureImageWithPhoneCamera() async
  {
    //pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
    final pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);

    if(pickedImageXFile != null)
    {
      final bytesOfImage = await pickedImageXFile.readAsBytes();

      setSelectedImage(bytesOfImage);
      setSelectedImageName(path.basename(pickedImageXFile.path));
      Get.back();
    }

    // print("imageSelectedName:: " + imageSelectedName.toString());
    // print("base64Encode(imageSelectedByte):: " + base64Encode(imageSelectedByte).toString());
    // print("imageSelectedByte:: " + imageSelectedByte.toString());

  }

  pickImageFromPhoneGallery() async
  {
    final pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedImageXFile != null)
    {
      final bytesOfImage = await pickedImageXFile.readAsBytes();

      setSelectedImage(bytesOfImage);
      setSelectedImageName(path.basename(pickedImageXFile.path));
      Get.back();
    }

    // print("imageSelectedName:: " + imageSelectedName.toString());
    // print("base64Encode(imageSelectedByte):: " + base64Encode(imageSelectedByte).toString());
    // print("imageSelectedByte:: " + imageSelectedByte.toString());

  }

  showDialogBoxForImagePickingAndCapturing(context)
  {
    return showDialog(
        context: context,
        builder: (context)
        {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Item Image",
              style: TextStyle(
                color: Colors.brown,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: ()
                {
                  captureImageWithPhoneCamera();
                },
                child: const Text(
                  "Capture with Phone Camera",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  pickImageFromPhoneGallery();
                },
                child: const Text(
                  "Pick Image From Phone Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

//----------------------------------------------------------------


  saveNewProduct() async{

    //print("base64Encode(imageSelectedByte):: " + base64Encode(imageSelectedByte).toString());

    Almacen almacen = Almacen(
      // almacen_id: 1,
      codigo: codigoController.text.trim(),
      producto: productoController.text.trim(),
      categoria: categoriaController.text.trim(),
      costo: double.parse(costoController.text.trim()),
      unidad: unidadController.text.trim(),
      inicial: 0,
      entrada: 0,
      salida: 0,
      finale: 0,
      variacion: double.parse(costoController.text.trim()),
      pvpa: double.parse(pvpaController.text.trim()),
      pvpb: double.parse(pvpbController.text.trim()),
      image: DateTime.now().millisecondsSinceEpoch.toString() + "-" + imageSelectedName,
      //image: imageSelectedName,
      //dateTime: DateTime.now(),
    );

    try
    {
      var response = await http.post(
        Uri.parse(API.saveNewProduct),
        body: almacen.toJson(base64Encode(imageSelectedByte)),
      );

      if(response.statusCode == 200)
      {
        var resBodyOfUploadItem = jsonDecode(response.body);

        if(resBodyOfUploadItem['success'] == true)
        {
          Fluttertoast.showToast(msg: "New item uploaded successfully");

          // setState(() {
          //   pickedImageXFile=null;
          //   nameController.clear();
          //   ratingController.clear();
          //   // tagsController.clear();
          //   unitController.clear();
          //   costController.clear();
          //   sale1Controller.clear();
          //   sale2Controller.clear();
          //   // sizesController.clear();
          //   // colorsController.clear();
          //   descriptionController.clear();
          // });

          //Get.to(defaultScreen);
          Get.back();
          //Get.to(ItemFragmentScreen());
        }
        else
        {
          Fluttertoast.showToast(msg: "Item not uploaded. Error, Try Again.");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        //automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          "Nuevo Producto",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              //display selected image by user
              Obx(()=> ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  maxHeight: MediaQuery.of(context).size.width * 0.6,
                ),
                child: imageSelectedByte.length > 0
                    ? Image.memory(imageSelectedByte, fit: BoxFit.contain,)
                    : const Placeholder(color: Colors.brown,),
              )),
              const SizedBox(height: 10),
              //select image btn
              Material(
                elevation: 1,
                color: Colors.brown.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
                child: InkWell(
                  onTap: ()
                  {
                    showDialogBoxForImagePickingAndCapturing(context);
                  },
                  borderRadius: BorderRadius.circular(3),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    child: Text(
                      "Select Image",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //fill item form
              Form(
                key: formKey,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        //codigo - unidad - categoria
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //codigo
                            Container(
                              width: 150,
                              height: 40,
                              child: TextFormField(
                                controller: codigoController,
                                validator: (val) => val == "" ? "Please write codigo" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.code,
                                    color: Colors.brown,
                                  ),
                                  hintText: "Codigo...",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.brown,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            const Spacer(),
                            //unidad
                            Container(
                              width: 80,
                              height: 40,
                              child: TextFormField(
                                controller: unidadController,
                                validator: (val) => val == "" ? "Please write unit" : null,
                                decoration: InputDecoration(
                                  hintText: "Unidad...",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.brown,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            const Spacer(),
                            //categoria
                            Container(
                              width: 120,
                              height: 40,
                              child: TextFormField(
                                controller: categoriaController,
                                validator: (val) => val == "" ? "Please write categoria" : null,
                                decoration: InputDecoration(
                                  hintText: "Categoria",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.brown,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        //item description
                        TextFormField(
                          controller: productoController,
                          validator: (val) => val == "" ? "Please write item description" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.description,
                              color: Colors.brown,
                            ),
                            hintText: "Productos (description)...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(
                                color: Colors.brown,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 15),
                        //costo - PVPA - PVPB
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //costo
                            Container(
                              width: 120,
                              height: 40,
                              child: TextFormField(
                                controller: costoController,
                                validator: (val) => val == "" ? "Please write costo" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.price_change_outlined,
                                    color: Colors.brown,
                                  ),
                                  hintText: "Costo",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.brown,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            const Spacer(),
                            //pvpa
                            Container(
                              width: 120,
                              height: 40,
                              child: TextFormField(
                                controller: pvpaController,
                                validator: (val) => val == "" ? "Please write PVPA" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.price_change_outlined,
                                    color: Colors.brown,
                                  ),
                                  hintText: "PVPA",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.brown,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            const Spacer(),
                            //pvpb
                            Container(
                              width: 120,
                              height: 40,
                              child: TextFormField(
                                controller: pvpbController,
                                validator: (val) => val == "" ? "Please write PVPB" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.price_change_outlined,
                                    color: Colors.brown,
                                  ),
                                  hintText: "PVPB",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.brown,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        //confirm and proceed btn
                        Obx(()=> Material(
                          elevation: 1,
                          color: imageSelectedByte.length > 0 ? Colors.brown : Colors.brown.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                          child: InkWell(
                            onTap: ()
                            {
                              if(imageSelectedByte.length > 0)
                              {
                                //save product info
                                //saveNewOrderInfo();
                                saveNewProduct();
                              }
                              else
                              {
                                Fluttertoast.showToast(msg: "Please attach new product / screenshot.");
                              }
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                              child: Text(
                                "Confirmed & Proceed",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        )),

                      ],
                    ),
                  ),
                ),
              )
              //save button
            ],
          ),
        ),
      ),
    );
  }
}
