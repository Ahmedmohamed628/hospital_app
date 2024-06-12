class Ambulance {
  final String id;
  String name;
  bool isWorking; // Remove final keyword to allow modification

  Ambulance({required this.id, required this.name, required this.isWorking});
}
