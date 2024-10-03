import 'city.dart';

class UploadState {
  int id;
  String name;
  List<Cities> chosenCities;

  UploadState({
    required this.id,
    required this.name,
    required this.chosenCities,
  });

  @override
  String toString() {
    return 'UploadState{id: $id, name: $name, chosenCities: $chosenCities}';
  }
}
