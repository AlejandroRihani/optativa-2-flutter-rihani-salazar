import 'package:proyecto_alejandro_rihani/modules/categories/domain/dto/category/category_dto.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/domain/repository/category/category_repository.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/useCase/use_case.dart';

class GetCategoriesUseCase implements UseCase<List<Category>, void> {
  final CategoryRepository _categoryRepository;

  GetCategoriesUseCase(this._categoryRepository);

  @override
  Future<List<Category>> execute(void params) async {
    return await _categoryRepository.execute(params);
  }
}
