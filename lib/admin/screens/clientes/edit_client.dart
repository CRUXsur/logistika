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



class EditClient extends StatefulWidget {

  final Clientes? clickedClienteEdit;

  const EditClient({super.key, this.clickedClienteEdit});

  @override
  State<EditClient> createState() => _EditClientState();
}

class _EditClientState extends State<EditClient> {

  //controllers for add items model
  var formKey = GlobalKey<FormState>();
  TextEditingController negocioController = TextEditingController();
  TextEditingController contactoController = TextEditingController();
  TextEditingController movilController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController razonController = TextEditingController();
  TextEditingController nitController = TextEditingController();

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

//update Client
  updateClient() async{

    try
    {
      var res = await http.post(
          Uri.parse(API.editClient),
          body:
          {
            "cliente_id": widget.clickedClienteEdit!.cliente_id.toString(),
            "negocio": negocioController.text.trim(),
            "categoria": categoriaController.text.trim(),
            "tipo": tipoController.text.trim(),
            "contacto": contactoController.text.trim(),
            "razonSocial": razonController.text.trim(),
            "nit": nitController.text.trim(),
            "movil": movilController.text.trim(),
          }
      );

      if(res.statusCode == 200)
      {
        var resBodyOfUploadItem = jsonDecode(res.body);

        if(resBodyOfUploadItem['success'] == true)
        {
          Fluttertoast.showToast(msg: "Updated successfully");

          //Get.to(ClientesScreen);
          Get.back();
          //Get.to(ItemFragmentScreen());

        }
        else
        {
          Fluttertoast.showToast(msg: "Client not updated. Error, Try Again.");
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

    negocioController.text = widget.clickedClienteEdit!.negocio.toString();
    contactoController.text = widget.clickedClienteEdit!.contacto.toString();
    movilController.text = widget.clickedClienteEdit!.movil.toString();
    categoriaController.text = widget.clickedClienteEdit!.categoria.toString();
    tipoController.text = widget.clickedClienteEdit!.tipo.toString();
    razonController.text = widget.clickedClienteEdit!.razonSocial.toString();
    nitController.text = widget.clickedClienteEdit!.nit.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        //automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          "Editar Cliente",
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
              //display client front image
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.width * 0.6,
                ),
                child: FadeInImage(
                  placeholder: const AssetImage("assets/no-image.jpg"),
                  image: NetworkImage(
                    API.hostImagesClients + widget.clickedClienteEdit!.image!,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //select image btn
              // Material(
              //   elevation: 1,
              //   color: Colors.indigo.withOpacity(0.8),
              //   borderRadius: BorderRadius.circular(3),
              //   child: InkWell(
              //     onTap: ()
              //     {
              //       showDialogBoxForImagePickingAndCapturing(context);
              //     },
              //     borderRadius: BorderRadius.circular(3),
              //     child: const Padding(
              //       padding: EdgeInsets.symmetric(
              //         horizontal: 30,
              //         vertical: 12,
              //       ),
              //       child: Text(
              //         "Front Image",
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 18,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
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

                        //Cliente
                        TextFormField(
                          controller: negocioController,
                          validator: (val) => val == "" ? "Cliente" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.add_business_outlined,
                              color: Colors.indigo,
                            ),
                            hintText: widget.clickedClienteEdit!.negocio.toString(),
                            //labelText: "Cliente",
                            labelText: widget.clickedClienteEdit!.negocio.toString(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(
                                color: Colors.indigo,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(
                                color: Colors.indigoAccent,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
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
                        //contacto - celular
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //contacto
                            Container(
                              width: 200,
                              height: 45,
                              child: TextFormField(
                                controller: contactoController,
                                validator: (val) => val == "" ? "Please write contacto" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.indigo,
                                  ),
                                  hintText: "Contacto",
                                  labelText: widget.clickedClienteEdit!.contacto.toString(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
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
                            //celular
                            Container(
                              width: 170,
                              height: 45,
                              child: TextFormField(
                                controller: movilController,
                                validator: (val) => val == "" ? "Please write celular" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: Colors.indigo,
                                  ),
                                  hintText: "Celular",
                                  labelText: widget.clickedClienteEdit!.movil.toString(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
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
                        //categoria - tipo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //categoria
                            Container(
                              width: 250,
                              height: 45,
                              child: TextFormField(
                                controller: categoriaController,
                                validator: (val) => val == "" ? "Please write categoria" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.account_tree,
                                    color: Colors.indigo,
                                  ),
                                  hintText: "Categoria",
                                  labelText: widget.clickedClienteEdit!.categoria.toString(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
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
                            //tipo
                            Container(
                              width: 120,
                              height: 45,
                              child: TextFormField(
                                controller: tipoController,
                                validator: (val) => val == "" ? "Please write tipo" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.type_specimen,
                                    color: Colors.indigo,
                                  ),
                                  hintText: "Tipo",
                                  labelText: widget.clickedClienteEdit!.tipo.toString(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
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
                        //razon social
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //razon social
                            Container(
                              width: 350,
                              height: 40,
                              child: TextFormField(
                                controller: razonController,
                                validator: (val) => val == "" ? "Please write razon social" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.abc,
                                    color: Colors.indigo,
                                  ),
                                  hintText: "razon social",
                                  labelText: widget.clickedClienteEdit!.razonSocial.toString(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
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
                            //const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 15),
                        //nit
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //nit
                            Container(
                              width: 250,
                              height: 40,
                              child: TextFormField(
                                controller: nitController,
                                validator: (val) => val == "" ? "Please write nit" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.numbers,
                                    color: Colors.indigo,
                                  ),
                                  hintText: "nit",
                                  labelText: widget.clickedClienteEdit!.nit.toString(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
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
                          //color: Colors.indigo,
                          color: imageSelectedByte.length > 0 ? Colors.indigo.withOpacity(0.2) : Colors.indigo,
                          borderRadius: BorderRadius.circular(3),
                          child: InkWell(
                            onTap: ()
                            {
                              //Keyboard unfocus!!
                              FocusScope.of(context).unfocus();

                              //update client info
                              updateClient();
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

