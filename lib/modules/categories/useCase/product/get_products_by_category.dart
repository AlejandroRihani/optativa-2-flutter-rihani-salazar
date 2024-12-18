import 'package:proyecto_alejandro_rihani/modules/categories/domain/dto/product/product_dto.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/domain/repository/product/product_repository.dart';

class GetProductsByCategoryUseCase {
  final ProductRepository _productRepository;

  GetProductsByCategoryUseCase(this._productRepository);

  Future<List<Product>> execute(String categorySlug) async {
    return await _productRepository.fetchProductsByCategory(categorySlug);
  }
}
