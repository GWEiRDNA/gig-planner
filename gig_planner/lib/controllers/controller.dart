import 'package:gig_planner_sketch/views/playlist.dart';

import '../models/models.dart';
import '../models/user_model.dart';

class Controller{
  UserModel user;

  Controller(this.user);

  //Events
  List<String> getEventNames(){
    List<String> eventNames = [];
    for(EventModel e in user.events){
      eventNames.add(e.name);
    }
    return eventNames;
  }

  String getEventName(String eventId){
    for(EventModel e in user.events){
      if(eventId == e.id){
        return e.name;
      }
    }
  }

  String getEventPermissions(String eventId){
    return "w";
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

  //- Playlist
  PlaylistModel getEventsPlaylist(String eventId){
    if(canReadEvent(eventId)){
      return
    }
    return ;
  }

}