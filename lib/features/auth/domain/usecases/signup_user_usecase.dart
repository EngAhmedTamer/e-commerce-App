import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
	final String email;
	final String password;
	SignUpParams(this.email, this.password);
}

class SignupUserUseCase implements UseCase<UserEntity, SignUpParams> {
	final AuthRepository repository;

	SignupUserUseCase(this.repository);

	@override
	Future<UserEntity> call(SignUpParams params) async {
		return await repository.signup(params.email, params.password);
	}
}


