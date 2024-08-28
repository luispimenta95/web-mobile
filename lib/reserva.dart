class Reserva {
  final int id;
  final String camArquivo;

  Reserva({required this.id, required this.camArquivo});

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'],
      camArquivo: json['camArquivo'],
    );
  }
}