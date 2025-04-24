class Almacen
{
  int? almacen_id;
  String? codigo;
  String? producto;
  String? categoria;
  double? costo;
  String? unidad;
  int? inicial;
  int? entrada;
  int? salida;
  int? finale;
  double? variacion;
  double? pvpa;
  double? pvpb;
  String? image;


  Almacen({
    this.almacen_id,
    this.codigo,
    this.producto,
    this.categoria,
    this.costo,
    this.unidad,
    this.inicial,
    this.entrada,
    this.salida,
    this.finale,
    this.variacion,
    this.pvpa,
    this.pvpb,
    this.image,
  });

  factory Almacen.fromJson(Map<String, dynamic> json) => Almacen(
    almacen_id: int.parse(json["almacen_id"]),
    codigo: json["codigo"],
    producto: json["producto"],
    categoria: json["categoria"],
    costo: double.parse(json["costo"]),
    unidad: json["unidad"],
    inicial: int.parse(json["inicial"]),
    entrada: int.parse(json["entrada"]),
    salida: int.parse(json["salida"]),
    finale: int.parse(json["finale"]),
    variacion: double.parse(json["variacion"]),
    pvpa: double.parse(json["pvpa"]),
    pvpb: double.parse(json["pvpb"]),
    image: json['image'],
  );

  Map<String, dynamic> toJson(String imageSelectedBase64)=>
      {
        "almacen_id": almacen_id.toString(),
        "codigo": codigo,
        "producto": producto,
        "categoria": categoria,
        "costo": costo!.toStringAsFixed(2),
        "unidad": unidad,
        "inicial": inicial.toString(),
        "entrada": entrada.toString(),
        "salida": salida.toString(),
        "finale": finale.toString(),
        "variacion": variacion!.toStringAsFixed(2),
        "pvpa": pvpa!.toStringAsFixed(2),
        "pvpb": pvpb!.toStringAsFixed(2),
        "image": image,
        "imageFile": imageSelectedBase64,
      };


}