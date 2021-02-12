import 'package:contactmanagement/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
class MyScopedModel extends Model{
  bool _isloading = false;
  bool get isloading => _isloading;

  bool _loginInProgress = false;
  bool get loginInProgress => _loginInProgress;


  Future<Map<String,dynamic>> registerUser(UserModel user) async{
    _isloading=true;
    FirebaseAuth auth = FirebaseAuth.instance;
   try {
     final User loggedInUser = (await auth.createUserWithEmailAndPassword(
         email: user.email, password: user.password)).user;
     String uid = loggedInUser.uid;
     _isloading=false;
     return{'success': true, 'message': 'Logged In Success'};
   } catch (e){
     _isloading=false;
     notifyListeners();
     return{'success': false, 'message': e.message};
   }

  }

  Future<Map<String,dynamic>> logInUser(UserModel user) async{
    _loginInProgress=true;
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final User loggedInUser = (await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password)).user;
      String uid = loggedInUser.uid;
      _loginInProgress=false;
      return{'success': true, 'message': 'Logged In Success'};
    } catch (e){
      _loginInProgress=false;
      notifyListeners();
      return{'success': false, 'message': e.message};
    }

  }
}