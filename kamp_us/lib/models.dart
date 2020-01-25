class AccountModel {
  int id;
  String email;
  String passwd;
  String nickname;
  AccountModel(this.id,this.email,this.passwd,this.nickname);
}

class LocationModel {
  int id;
  int userId;
  String name;
  String description;
  double longitude;
  double latitude;
  bool verified;
  LocationModel(this.id,this.userId,this.name,this.description,this.longitude,this.latitude,this.verified);
}

class TagModel {
  int id;
  String tag;
  TagModel(this.id,this.tag);
}

class LocTagModel {
  int id;
  int locId;
  int tagId;
  LocTagModel(this.id,this.locId,this.tagId);
}

class ThumbModel {
  int id;
  int userId;
  int locId;
  ThumbModel(this.id,this.userId,this.locId);
}

class CommentModel {
  int id;
  int userId;
  int locId;
  String text;
  CommentModel(this.id,this.userId,this.locId,this.text);
}