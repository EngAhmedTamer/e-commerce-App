import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class AuthParams {
	final String email;
	final String password;
	AuthParams(this.email, this.password);
}

class AuthenticateUserUseCase implements UseCase<UserEntity, AuthParams> {
	final AuthRepository repository;

	AuthenticateUserUseCase(this.repository);

	@override
	Future<UserEntity> call(AuthParams params) async {
		return await repository.login(params.email, params.password);
	}
}


