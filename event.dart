class Event {
  final String id;
  String name;
  String description;
  final List<dynamic> pictures;
  String organizatorId;
  String facultaty;
  String time;
  List<dynamic>? listOfStringPictures;

  Event(
    this.id,
    this.name,
    this.description,
    this.pictures,
    this.organizatorId,
    this.facultaty,
    this.time,
  );

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'pictures': pictures,
        'organizator': organizatorId,
        'facultaty': facultaty,
        'time': time,
      };

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      map['id'],
      map['title'],
      map['description'],
      map['imageList'],
      map['idCreatedBy'],
      map['facultaty'],
      map['dateTime'],
    );
  }
}
