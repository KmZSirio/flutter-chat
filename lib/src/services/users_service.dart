import 'package:http/http.dart' as http;
import 'package:realtime_chat/src/global/environment.dart';
import 'package:realtime_chat/src/models/user.dart';
import 'package:realtime_chat/src/models/userslist_response.dart';
import 'package:realtime_chat/src/services/auth_service.dart';

class UsersService {

  Future<List<User>> getUsers() async {

    try {

      final resp = await http.get('${ Environment.apiUrl }/users', 
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );

      final usersResponse = usersListResponseFromJson( resp.body );
      return usersResponse.users;
    } catch(e) {
      return [];
    }
  }
}