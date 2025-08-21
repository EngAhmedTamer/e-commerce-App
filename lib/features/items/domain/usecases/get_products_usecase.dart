import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
	final ProductRepository repository;

	GetProductsUseCase(this.repository);

	@override
	Future<List<ProductEntity>> call(NoParams params) async {
		return await repository.getProducts();
	}
}


