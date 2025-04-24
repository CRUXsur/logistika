class API {
  static const hostConnect = "http://quanticasoft.com/api_logistika";
  static const hostAdmin = "$hostConnect/admin";
  static const hostClientes = "$hostConnect/clientes";
  static const hostAlmacen = "$hostConnect/almacen";

  static const hostImagesClients = "$hostConnect/clients_images/";
  static const hostImagesProducts = "$hostConnect/products_images/";


  //signUp-Login admin
  static const validateEmail = "$hostAdmin/validate_email.php";
  static const signUp = "$hostAdmin/signup.php";
  static const login = "$hostAdmin/login.php";

  //clientes
  static const getAllClient = "$hostClientes/all.php";
  static const saveNewClient = "$hostClientes/save.php";
  static const updateTotalCompra = "$hostClientes/updatecompra.php";
  static const editClient = "$hostClientes/edit.php";

  //almacen
  static const saveNewProduct = "$hostAlmacen/save.php";
  static const getAllItems = "$hostAlmacen/all.php";
  static const getRepoItems = "$hostAlmacen/repo.php";
  static const searchItems = "$hostAlmacen/search.php";
  static const editAlmacen = "$hostAlmacen/edit.php";

}