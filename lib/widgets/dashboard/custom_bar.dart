import 'package:flutter/material.dart';



import '../widgets.dart';



//SignOut


class CustomBar extends StatelessWidget {
  const CustomBar({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        //color: Colors.deepOrange.withOpacity(0.2), //Color(0xFFF2F3EE),
        // color: Colors.deepPurple.withOpacity(0.4),
        color: Colors.blueGrey.withOpacity(0.8),
        width: double.infinity,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //add new cliente
              BtnCircular(
                color: Colors.deepOrange,
                width: 50,//30
                child: const FadeInImage(
                  placeholder: AssetImage('assets/images/clientes.png'),
                  image: AssetImage('assets/images/clientes.png'),
                ),
                onTap: (){
                  //
                  // Get.to( ClientesScreen());
                },
              ),
              const Spacer(),
              //add new producto
              BtnCircular(
                color: Colors.deepOrange,
                width: 50,//30
                child: const FadeInImage(
                  placeholder: AssetImage('assets/images/productos.png'),
                  image: AssetImage('assets/images/productos.png'),
                ),
                onTap: (){
                  //go2almacen screen
                  // Get.to( AlmacenScreen());
                },
              ),
              const Spacer(),
              //add new ventas
              BtnCircular(
                color: Colors.deepOrange,
                width: 50,//30
                child: const FadeInImage(
                  placeholder: AssetImage('assets/images/ventas.png'),
                  image: AssetImage('assets/images/ventas.png'),
                ),
                onTap: (){
                  //go2almacen screen
                  // Get.to( const VentasScreen());
                },
              ),
              const Spacer(),
              //add new pedido
              BtnCircular(
                color: Colors.deepOrange,
                width: 50,//30
                child: const FadeInImage(
                  placeholder: AssetImage('assets/images/compras.png'),
                  image: AssetImage('assets/images/compras.png'),
                ),
                onTap: (){
                  //go2compras screen
                  // Get.to( const ComprasScreen());
                },
              ),
              const Spacer(),
              //signOut
              // BtnCircular(
              //   color: Colors.deepOrange,
              //   width: 30,
              //   child: const FadeInImage(
              //     placeholder: AssetImage('assets/images/logout.png'),
              //     image: AssetImage('assets/images/logout.png'),
              //   ),
              //   onTap: (){
              //     signOutAdmin();
              //   },
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
