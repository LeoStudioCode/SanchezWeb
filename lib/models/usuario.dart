class Usuario {
  final String email;
  final String name;
  final String nomina;
  final String rol;
  final String telefono;
  final String uid;

  Usuario({
    required this.email,
    required this.name,
    required this.nomina,
    required this.rol,
    required this.telefono,
    required this.uid,
  });

  // Método para convertir el objeto a un mapa para guardarlo en Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'nomina': nomina,
      'rol': rol,
      'telefono': telefono,
      'uid': uid,
    };
  }

  // Método para crear un objeto Usuario a partir de un mapa de Firestore
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      email: map['email'],
      name: map['name'],
      nomina: map['nomina'],
      rol: map['rol'],
      telefono: map['telefono'],
      uid: map['uid'],
    );
  }
}
