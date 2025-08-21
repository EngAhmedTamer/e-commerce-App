import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase implements UseCase<bool, NoParams> {
	final AuthRepository repository;

	CheckAuthStatusUseCase(this.repository);

	@override
	Future<bool> call(NoParams params) async {
		return await repository.isAuthenticated();
	}
}


