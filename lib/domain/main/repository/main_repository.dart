import 'package:chipmunk_flutter/core/util/usecase.dart';
import 'package:chipmunk_flutter/domain/main/entity/book_entity.dart';

abstract class MainRepository {
  Future<ChipmunkResult<BookEntity>> getBookList();
}
