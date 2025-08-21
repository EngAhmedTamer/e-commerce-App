import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class CreateProductParams {
	final ProductEntity product;
	CreateProductParams(this.product);
}

class CreateProductUseCase implements UseCase<bool, CreateProductParams> {
	final ProductRepository repository;

	CreateProductUseCase(this.repository);

	@override
	Future<bool> call(CreateProductParams params) async {
		return await repository.createItem(params.product);
	}
}


