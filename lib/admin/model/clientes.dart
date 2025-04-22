class Clientes
{
  int? cliente_id;
  String? codigo;
  String? negocio;
  String? categoria;
  String? tipo;
  String? contacto;
  String? razonSocial;
  String? nit;
  String? latitude;
  String? longitude;
  String? fijo;
  String? movil;
  String? email;
  double? totalCompra;
  String? image;

  Clientes({
    this.cliente_id,
    this.codigo,
    this.negocio,
    this.categoria,
    this.tipo,
    this.contacto,
    this.razonSocial,
    this.nit,
    this.latitude,
    this.longitude,
    this.fijo,
    this.movil,
    this.email,
    this.totalCompra,
    this.image,
  });

  factory Clientes.fromJson(Map<String, dynamic> json) => Clientes(
    cliente_id: int.parse(json["cliente_id"]),
    codigo: json["codigo"],
    negocio: json["negocio"],
    categoria: json["categoria"],
    tipo: json["tipo"],
    contacto: json["contacto"],
    razonSocial: json["razonSocial"],
    nit: json["nit"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    fijo: json["fijo"],
    movil: json["movil"],
    email: json["email"],
    totalCompra: double.parse(json["totalCompra"]),
    image: json['image'],
  );


  Map<String, dynamic> toJson(String imageSelectedBase64) =>
      {
        "cliente_id": cliente_id.toString(),
        "codigo": codigo,
        "negocio": negocio,
        "categoria": categoria,
        "tipo": tipo,
        "contacto": contacto,
        "razonSocial": razonSocial,
        "nit": nit,
        "latitude": latitude,
        "longitude": longitude,
        "fijo": fijo,
        "movil": movil,
        "email": email,
        "totalCompra": totalCompra!.toStringAsFixed(2),
        "image": image,
        "imageFile": imageSelectedBase64,
      };
}