import 'package:mvvm_project/domain/entities/auth_session.dart';
import 'package:mvvm_project/data/interfaces/mapper/imapper.dart';
import 'package:mvvm_project/domain/entities/user.dart';
import 'package:mvvm_project/data/dtos/login/login_response_dto.dart';

class AuthSessionMapper implements IMapper<LoginResponseDto, AuthSession> {
  @override
  AuthSession map(LoginResponseDto input) {
    // TODO: implement map
    return AuthSession(
      token: input.token,
      user: User(
        id: input.user.id,
        userName: input.user.userName,
      ),
    );
  }
}
