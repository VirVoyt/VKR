part of 'demo.dart';

//тест подключения
void testConnection() async {
  var person = ParseObject('Person')
    ..set('name', 'VV')
    ..set('age', 22);

  var response = await person.save();

  if (response.success) {
    print("Successfully connected to Back4app!");
  } else {
    print("Connection error: ${response.error?.message}");
  }
}