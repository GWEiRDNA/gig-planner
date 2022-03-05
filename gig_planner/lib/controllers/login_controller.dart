class LoginController{
  bool login(String eMail, String password){
    if(eMail == "admin" && password =="admin") {
      return true;
    }
    return false;
  }

  bool register(String nick, String eMail, String password) {
    return true;
  }
}