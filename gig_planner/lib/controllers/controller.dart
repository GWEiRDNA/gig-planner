import 'package:gig_planner_sketch/views/playlist.dart';

import '../models/models.dart';
import '../models/user_model.dart';

class Controller{
  UserModel user;

  Controller(this.user);

  //Events
  bool eventAvailable(String eventId){
    for(EventModel e in user.events){
      if(e.id == eventId){
        return true;
      }
    }
    return false;
  }

  List<String> getEventsIds(){
    List<String> eventIds = [];
    for(EventModel e in user.events){
      eventIds.add(e.id);
    }
    return eventIds;
  }

  String getEventName(String eventId){
    for(EventModel e in user.events){
      if(eventId == e.id){
        return e.name;
      }
    }
    //This doesn't happen
    return "";
  }

  String getEventPermissions(String eventId){
    return "w";
  }

  PlaylistModel? getEventPlaylistModel(String eventId){
    EventModel event = user.events.firstWhere((e) => e.id == eventId);
    return event.playlist;
  }

  bool canReadEvent(String eventId){
    String permissions = getEventPermissions(eventId);
    switch(permissions){
      case "w":
        {
          return true;
        }
      case "r":
        {
          return true;
        }
      default: {
          return false;
      }
    }
  }

}