import 'package:flutter/material.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/domain/dto/product/product_dto.dart';
import 'package:proyecto_alejandro_rihani/screens/login_page.dart';
import 'package:proyecto_alejandro_rihani/screens/category_page.dart';
import 'package:proyecto_alejandro_rihani/screens/products_by_cat_page.dart';
import 'package:proyecto_alejandro_rihani/screens/product_page.dart';
import 'package:proyecto_alejandro_rihani/screens/cart_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String categories = '/categories';
  static const String productsByCategory = '/products_by_category';
  static const String productDetail = '/product_detail';
  static const String cart = '/cart';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    categories: (context) => const CategoriesPage(),
    productsByCategory: (context) => ProductsByCategoryPage(
      categorySlug: ModalRoute.of(context)!.settings.arguments as String,
      categoryName: ModalRoute.of(context)!.settings.arguments as String,
    ),
    productDetail: (context) => ProductDetailPage(
      product: ModalRoute.of(context)!.settings.arguments as Product,
    ),
    cart: (context) => const CartPage(),
  };
}
