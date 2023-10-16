import 'package:VietQR/models/contact_dto.dart';
import 'package:flutter/material.dart';

class WalletProvider extends ChangeNotifier {
  final List<CategoryModel> _listCategories = [
    CategoryModel(
      title: 'Cộng đồng',
      url: 'assets/images/gl-white.png',
      type: 8,
    ),
    CategoryModel(
      title: 'Cá nhân',
      url: 'assets/images/ic-personal-white.png',
      type: 9,
    ),
    CategoryModel(
      title: 'VCard',
      url: 'assets/images/ic-contact-bank-white.png',
      type: 4,
    ),
    CategoryModel(
      title: 'Ngân hàng',
      url: 'assets/images/ic-contact-all-white.png',
      type: 2,
    ),
    CategoryModel(
      title: 'VietQR ID',
      url: 'assets/images/ic-contact-vietqr-id-white.png',
      type: 1,
    ),
    CategoryModel(
      title: 'Khác',
      url: 'assets/images/qr-contact-other-white.png',
      type: 3,
    ),
    CategoryModel(
      title: 'Gợi ý',
      url: 'assets/images/ic-contact-suggest-white.png',
      type: 0,
    ),
  ];
  List<CategoryModel> get listCategories => _listCategories;

  CategoryModel _categoryModel = CategoryModel(
    title: 'Cộng đồng',
    url: 'assets/images/gl-white.png',
    type: 8,
  );
  CategoryModel get categoryModel => _categoryModel;

  ContactDTO _contactSelected = ContactDTO();
  ContactDTO get contactSelected => _contactSelected;

  String _keyWordSearch = '';
  String get keyWordSearch => _keyWordSearch;

  onChangeCategory(CategoryModel value) {
    _categoryModel = value;
    notifyListeners();
  }

  changeContactDto(ContactDTO dto) {
    _contactSelected = dto;
    notifyListeners();
  }

  updateKeywordSearch(String value) {
    _keyWordSearch = value;
  }
}

class CategoryModel {
  final String title;
  final String url;
  final int type;

  CategoryModel({
    this.title = '',
    this.url = '',
    this.type = 0,
  });
}
