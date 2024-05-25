import 'package:hackaton/models/appuser.dart';

class Event {
  final String id;
  String name;
  String description;
  final List<dynamic> pictures;
  AppUser organizator;
  String facultaty;
  DateTime time;
  List<dynamic>? listOfStringPictures;

  Event(
    this.id,
    this.name,
    this.description,
    this.pictures,
    this.organizator,
    this.facultaty,
    this.time,
  );

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'pictures': pictures,
        'organizator': organizator,
        'facultaty': facultaty,
        'time': time,
      };

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      map['id'],
      map['title'],
      map['description'],
      map['imageList'],
      map['organizator'],
      map['facultaty'],
      map['time'],
    );
  }
}
