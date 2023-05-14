import 'package:flutter_test/flutter_test.dart';
import 'package:simple_firebase_crud_cubit/src/model/my_user.dart';

void main() {
  group('MyUser', () {
    late MyUser myUser;

    setUp(() {
      myUser = MyUser(
        id: '1',
        name: 'John',
        lastName: 'Doe',
        age: 30,
        image: 'https://example.com/image.jpg',
      );
    });

    test('supports value equality', () {
      final copy = myUser.copyWith();

      expect(myUser, copy);
      expect(myUser.hashCode, copy.hashCode);
    });

    test('copyWith returns a new object with only specified properties changed',
        () {
      final copy = myUser.copyWith(name: 'Jane', age: 25);

      expect(copy.id, equals(myUser.id));
      expect(copy.name, equals('Jane'));
      expect(copy.lastName, equals(myUser.lastName));
      expect(copy.age, equals(25));
      expect(copy.image, equals(myUser.image));
    });

    test('creates object from Firebase map', () {
      final data = {
        'id': '2',
        'name': 'Mary',
        'lastName': 'Smith',
        'age': 35,
        'image': 'https://example.com/image2.jpg',
      };

      final user = MyUser.fromFirebaseMap(data);

      expect(user.id, equals('2'));
      expect(user.name, equals('Mary'));
      expect(user.lastName, equals('Smith'));
      expect(user.age, equals(35));
      expect(user.image, equals('https://example.com/image2.jpg'));
    });

    test('converts object to Firebase map', () {
      final map = myUser.toFirebaseMap();

      expect(map['id'], equals('1'));
      expect(map['name'], equals('John'));
      expect(map['lastName'], equals('Doe'));
      expect(map['age'], equals(30));
      expect(map['image'], equals('https://example.com/image.jpg'));
    });
  });
}
