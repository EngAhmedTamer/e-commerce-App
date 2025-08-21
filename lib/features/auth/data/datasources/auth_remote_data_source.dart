import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
	Future<UserEntity> login(String email, String password);
	Future<UserEntity> signup(String email, String password);
	Future<void> logout();
	Future<bool> isAuthenticated();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
	final SupabaseClient client;

	AuthRemoteDataSourceImpl({required this.client});

	@override
	Future<UserEntity> login(String email, String password) async {
		final res = await client.auth.signInWithPassword(email: email, password: password);
		final user = res.user;
		if (user == null) throw Exception('Login failed');
		return UserEntity(id: user.id, email: user.email ?? '');
	}

	@override
	Future<UserEntity> signup(String email, String password) async {
		final res = await client.auth.signUp(email: email, password: password);
		final user = res.user;
		if (user == null) throw Exception('Signup failed');
		return UserEntity(id: user.id, email: user.email ?? '');
	}

	@override
	Future<void> logout() async {
		await client.auth.signOut();
	}

	@override
	Future<bool> isAuthenticated() async {
		return client.auth.currentUser != null;
	}
}


