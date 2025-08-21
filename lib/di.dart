import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart' as domain_auth_repo;
import 'features/auth/domain/usecases/authenticate_user_usecase.dart';
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'features/auth/domain/usecases/signup_user_usecase.dart';
import 'features/auth/view_model/auth_view_model.dart';

import 'features/items/data/datasources/product_remote_data_source.dart';
import 'features/items/data/repositories/product_repository_impl.dart';
import 'features/items/domain/repositories/product_repository.dart';
import 'features/items/domain/usecases/create_product_usecase.dart';
import 'features/items/domain/usecases/delete_product_usecase.dart';
import 'features/items/domain/usecases/get_products_usecase.dart';
import 'features/items/domain/usecases/update_product_usecase.dart';
import 'features/items/domain/usecases/upload_image_usecase.dart';
import 'features/items/view_model/items_view_model.dart';

class _ServiceLocator {
	final Map<Type, dynamic> _singletons = {};
	final Map<Type, dynamic Function()> _factories = {};

	T get<T>() {
		if (_singletons.containsKey(T)) return _singletons[T] as T;
		if (_factories.containsKey(T)) return _factories[T]!() as T;
		throw StateError('Service of type $T not found');
	}

	void registerSingleton<T>(T instance) {
		_singletons[T] = instance;
	}

	void registerFactory<T>(T Function() factory) {
		_factories[T] = factory;
	}
}

final sl = _ServiceLocator();

Future<void> initDependencies() async {
	// External
	sl.registerSingleton<SupabaseClient>(Supabase.instance.client);

	// Auth (register only fundamentals; build usecases inline for simplicity)
	sl.registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(client: sl.get()));
	sl.registerFactory<domain_auth_repo.AuthRepository>(() => AuthRepositoryImpl(remote: sl.get()));
	sl.registerFactory<AuthViewModel>(() => AuthViewModel(
		authenticateUserUseCase: AuthenticateUserUseCase(sl.get()),
		signupUserUseCase: SignupUserUseCase(sl.get()),
		checkAuthStatusUseCase: CheckAuthStatusUseCase(sl.get()),
	));

	// Products (register only fundamentals; build usecases inline for simplicity)
	sl.registerFactory<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(client: sl.get()));
	sl.registerFactory<ProductRepository>(() => ProductRepositoryImpl(sl.get()));
	sl.registerFactory<ItemsViewModel>(() => ItemsViewModel(
		getProductsUseCase: GetProductsUseCase(sl.get()),
		createProductUseCase: CreateProductUseCase(sl.get()),
		updateProductUseCase: UpdateProductUseCase(sl.get()),
		deleteProductUseCase: DeleteProductUseCase(sl.get()),
		uploadImageUseCase: UploadImageUseCase(sl.get()),
	));
}


