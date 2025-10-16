import 'user_model.dart';

UserModel? _registeredUser; 
UserModel? _currentUser;    

UserModel? get registeredUser => _registeredUser;
UserModel? get currentUser => _currentUser;

set registeredUser(UserModel? user) {
  _registeredUser = user;
}

set currentUser(UserModel? user) {
  _currentUser = user;
}
