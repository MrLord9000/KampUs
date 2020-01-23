class AccountModel {
  int id;
  String email;
  String passwd;
  String nickname;
}

class LocationModel {
  int id;
  int userId;
  String name;
  String description;
  double longitude;
  double latitude;
  bool verified;
}

class TagModel {
  int id;
  String tag;
}

class LocTagModel {
  int id;
  int locId;
  int tagId;
}

class ThumbModel {
  int id;
  int userId;
  int locId;
}

class CommentModel {
  int id;
  int userId;
  int locId;
  String text;
}