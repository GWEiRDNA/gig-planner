import '../models/models.dart';
import '../models/user_model.dart';

class Controller{
  UserModel user;

  Controller(this.user);

  //Events
  List<String> getAvailableEventsIds(){
    return user.getAvailableEventsIds();
  }
}