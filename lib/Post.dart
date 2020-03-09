class Post {
  int _UserId;
  int _id;
  String _title;
  String _body;

  Post(this._UserId, this._id, this._title, this._body);

  String get body => _body;

  set body(String value) {
    _body = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get UserId => _UserId;

  set UserId(int value) {
    _UserId = value;
  }

}