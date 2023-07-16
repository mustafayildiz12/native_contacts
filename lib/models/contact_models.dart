class ContactsModel {
  String? id;
  String? name;
  String? number;

  ContactsModel({this.id, this.name, this.number});

  ContactsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['number'] = number;
    return data;
  }
}
