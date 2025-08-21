import '../../../../core/usecase/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProductParams {
	final String name;
	DeleteProductParams(this.name);
}

class DeleteProductUseCase implements UseCase<bool, DeleteProductParams> {
	final ProductRepository repository;

	DeleteProductUseCase(this.repository);

	@override
	Future<bool> call(DeleteProductParams params) async {
		return await repository.deleteByName(params.name);
	}
}


