

import 'package:get/get.dart';

import '../model/model.dart';

class ClientListController extends GetxController
{
  //
  //init as empty list
  RxList<Clientes> _clientlist = <Clientes>[].obs;


  //"getter" to access variables
  List<Clientes> get clientList => _clientlist.value;

  //Methods! settings the values
  setList(List<Clientes> list)
  {
    _clientlist.value = list;
  }

}