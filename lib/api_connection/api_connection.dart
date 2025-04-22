class API {
  static const hostConnect = "http://quanticasoft.com/api_logistika";
  static const hostAdmin = "$hostConnect/admin";

  static const hostClientes = "$hostConnect/clientes";

  static const hostImagesClients = "$hostConnect/clients_images/";


  //signUp-Login admin
  static const validateEmail = "$hostAdmin/validate_email.php";
  static const signUp = "$hostAdmin/signup.php";
  static const login = "$hostAdmin/login.php";

  //clientes
  static const getAllClient = "$hostClientes/all.php";
  static const saveNewClient = "$hostClientes/save.php";
  static const updateTotalCompra = "$hostClientes/updatecompra.php";
  static const editClient = "$hostClientes/edit.php";

}