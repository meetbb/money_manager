import 'dart:async';

class CheckLoginBloc {

  StreamController<String> loginStreamController = new StreamController<String>();

  void checkLogin() {

  }

  void dispose() {
    loginStreamController.close();
  }

  Stream get getLoginStream =>  loginStreamController.stream;
}