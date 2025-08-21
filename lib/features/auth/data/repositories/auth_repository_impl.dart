import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart' as domain_repo;
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements domain_repo.AuthRepository {
	final AuthRemoteDataSource remote;

	AuthRepositoryImpl({required this.remote});

	@override
	Future<UserEntity> login(String email, String password) async {
		return await remote.login(email, password);
	}

	@override
	Future<UserEntity> signup(String email, String password) async {
		return await remote.signup(email, password);
	}

	@override
	Future<void> logout() async {
		await remote.logout();
	}

	@override
	Future<bool> isAuthenticated() async {
		return await remote.isAuthenticated();
	}
}


