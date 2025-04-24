



import 'package:get/get.dart';

import '../model/model.dart';

class AlmacenListController extends GetxController
{
  //
  //init as empty list
  RxList<Almacen> _almacenlist = <Almacen>[].obs;
  RxList<Almacen> _repolist = <Almacen>[].obs;


  //"getter" to access variables
  List<Almacen> get almacenList => _almacenlist.value;
  List<Almacen> get repoList => _repolist.value;

  //Methods! settings the values
  setList(List<Almacen> list)
  {
    _almacenlist.value = list;
  }

  setRepo(List<Almacen> repo)
  {
    _repolist.value = repo;
  }

}