import 'package:chipmunk_flutter/core/network/api/chipmunk_main_error_mapper.dart';
import 'package:chipmunk_flutter/core/network/api/chipmunk_main_response.dart';
import 'package:chipmunk_flutter/core/util/usecase.dart';
import 'package:chipmunk_flutter/data/main/datasource/main_datasource.dart';
import 'package:chipmunk_flutter/domain/main/entity/book_entity.dart';
import 'package:chipmunk_flutter/domain/main/repository/main_repository.dart';

class MainRepositoryImpl implements MainRepository {
  final MainDataSource mainDataSource;
  final ChipmunkErrorMapper errorMapper;

  MainRepositoryImpl({
    required this.mainDataSource,
    required this.errorMapper,
  });

  @override
  Future<ChipmunkResult<BookEntity>> getBookList() async {
    final remoteData = await mainDataSource.getBookList().toRemoteDomainData(errorMapper);
    return remoteData;
  }
}
