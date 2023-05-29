import 'package:chipmunk_flutter/core/network/api/chipmunk_main_response.dart';
import 'package:chipmunk_flutter/core/network/api/service/main_service.dart';
import 'package:chipmunk_flutter/data/main/response/book_response.dart';
import 'package:chipmunk_flutter/domain/main/entity/book_entity.dart';

abstract class MainDataSource {
  Future<BookEntity> getBookList();
}

class MainDataSourceImpl extends MainDataSource {
  final MainService mainService;

  MainDataSourceImpl(this.mainService);

  @override
  Future<BookEntity> getBookList() async {
    final response = await mainService.books().then((value) => value.toResponseData());
    final entity = BookResponse.fromJson(response);
    return entity;
  }
}
