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




class EditAlmacen extends StatefulWidget {

  final Almacen? clickedAlmacenInfo;

  const EditAlmacen({
    super.key,
    this.clickedAlmacenInfo,
  });

  @override
  State<EditAlmacen> createState() => _EditAlmacenState();
}

class _EditAlmacenState extends State<EditAlmacen> {

  //controllers for add items model
  var formKey = GlobalKey<FormState>();
  TextEditingController codigoController = TextEditingController();
  TextEditingController productoController = TextEditingController();
  TextEditingController unidadController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController costoController = TextEditingController();
  TextEditingController pvpaController = TextEditingController();
  TextEditingController pvpbController = TextEditingController();
  TextEditingController porcentajeController = TextEditingController();
  TextEditingController inicialController = TextEditingController();

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

//update Almacen
  updateAlmacen() async {
    try {
      // Tomar valores originales del producto
      final original = widget.clickedAlmacenInfo!;

      var res = await http.post(
        Uri.parse(API.editAlmacen),
        body: {
          "almacen_id": original.almacen_id.toString(),
          "codigo": original.codigo.toString(),
          "producto": productoController.text.trim().isNotEmpty
              ? productoController.text.trim()
              : original.producto.toString(),
          "unidad": unidadController.text.trim().isNotEmpty
              ? unidadController.text.trim()
              : original.unidad.toString(),
          "categoria": categoriaController.text.trim().isNotEmpty
              ? categoriaController.text.trim()
              : original.categoria.toString(),
          "costo": costoController.text.trim().isNotEmpty
              ? costoController.text.trim()
              : original.costo.toString(),
          "pvpa": pvpaController.text.trim().isNotEmpty
              ? pvpaController.text.trim()
              : original.pvpa.toString(),
          "pvpb": pvpbController.text.trim().isNotEmpty
              ? pvpbController.text.trim()
              : original.pvpb.toString(),
          "variacion": porcentajeController.text.trim().isNotEmpty
              ? porcentajeController.text.trim()
              : original.variacion.toString(),
          "inicial": inicialController.text.trim().isNotEmpty
              ? inicialController.text.trim()
              : original.inicial.toString(),
        },
      );

      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody["success"] == true) {
          Fluttertoast.showToast(msg: "Producto actualizado correctamente");
          Get.back(); // Vuelve a la pantalla anterior
        } else {
          Fluttertoast.showToast(msg: "Error al actualizar. Intenta de nuevo.");
        }
      } else {
        Fluttertoast.showToast(msg: "Error de servidor (status != 200)");
      }
    } catch (e) {
      print("Error:: $e");
    }
  }



  @override
  Widget build(BuildContext context) {

    codigoController.text = widget.clickedAlmacenInfo!.codigo.toString();
    productoController.text = widget.clickedAlmacenInfo!.producto.toString();
    unidadController.text = widget.clickedAlmacenInfo!.unidad.toString();
    categoriaController.text = widget.clickedAlmacenInfo!.categoria.toString();
    costoController.text = widget.clickedAlmacenInfo!.costo.toString();
    pvpaController.text = widget.clickedAlmacenInfo!.pvpa.toString();
    pvpbController.text = widget.clickedAlmacenInfo!.pvpb.toString();
    porcentajeController.text = widget.clickedAlmacenInfo!.variacion.toString();
    inicialController.text = widget.clickedAlmacenInfo!.inicial.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        //automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          "Editar Almacen",
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

              const SizedBox(height: 45),
              //display client front image
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.width * 0.6,
                ),
                child: FadeInImage(
                  placeholder: const AssetImage("assets/no-image.jpg"),
                  image: NetworkImage(
                    API.hostImagesProducts + widget.clickedAlmacenInfo!.image!,
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
                              width: 140,
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
                        const SizedBox(height: 15),
                        //porcentaje - inicial
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //porcentaje
                            Container(
                              width: 150,
                              height: 40,
                              child: TextFormField(
                                controller: porcentajeController,
                                validator: (val) => val == "" ? "Please write %" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.percent,
                                    color: Colors.brown,
                                  ),
                                  hintText: "Porcentaje",
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
                            //inicial
                            Container(
                              width: 120,
                              height: 40,
                              child: TextFormField(
                                controller: inicialController,
                                validator: (val) => val == "" ? "Please write inicial" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.numbers,
                                    color: Colors.brown,
                                  ),
                                  hintText: "Inicial",
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
                          ],
                        ),
                        const SizedBox(height: 45),
                        //confirm and proceed btn
                        Obx(()=> Material(
                          elevation: 1,
                          color: imageSelectedByte.length > 0 ? Colors.brown.withOpacity(0.2) : Colors.brown,
                          borderRadius: BorderRadius.circular(3),
                          child: InkWell(
                            onTap: ()
                            {

                              if(imageSelectedByte.length > 0)
                              {
                                Fluttertoast.showToast(msg: "Please attach new product / screenshot.");
                              }
                              else
                              {
                                //Keyboard unfocus!!
                                FocusScope.of(context).unfocus();

                                //save changes
                                updateAlmacen();

                              }
                            },

                            borderRadius: BorderRadius.circular(30),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                              child: Text(
                                "Aceptar",
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
