import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class UpdateProductParams {
	final String oldName;
	final ProductEntity newValue;
	UpdateProductParams({required this.oldName, required this.newValue});
}

class UpdateProductUseCase implements UseCase<bool, UpdateProductParams> {
	final ProductRepository repository;

	UpdateProductUseCase(this.repository);

	@override
	Future<bool> call(UpdateProductParams params) async {
		return await repository.updateItem(oldName: params.oldName, newValue: params.newValue);
	}
}


