import 'dart:io';
import '../../../../core/usecase/usecase.dart';
import '../repositories/product_repository.dart';

class UploadImageParams {
	final File file;
	UploadImageParams(this.file);
}

class UploadImageUseCase implements UseCase<String?, UploadImageParams> {
	final ProductRepository repository;

	UploadImageUseCase(this.repository);

	@override
	Future<String?> call(UploadImageParams params) async {
		return await repository.uploadImage(params.file);
	}
}


