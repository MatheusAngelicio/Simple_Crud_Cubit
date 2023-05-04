import 'dart:ffi';

class User {
  final String id;
  final String name;
  final String lastName;
  final int age;

  final String? image;

  const User(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.age,
      this.image});

  Map<String, Object?> toFirebaseMap() {
    return <String, Object?>{
      'id': id,
      'name': name,
      'lastName': lastName,
      'age': age,
      'image': image,
    };
  }

  User.fromFirebaseMap(Map<String, Object?> data)
      : id = data['id'] as String,
        name = data['name'] as String,
        lastName = data['lastName'] as String,
        age = data['age'] as int,
        image = data['image'] as String?;

  // o copyWith funciona assim
  // eu passo por parametro as propriedades que quero modificar
  // e a funcao verifica , se for nulo(se nao quero mudar tal propriedade),
  // entao continua o msm valor de antes, se eu passar algum valor, ai sera modificado

  User copyWith({
    String? id,
    String? name,
    String? lastName,
    int? age,
    String? image,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      image: image ?? this.image,
    );
  }
}
