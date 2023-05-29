import 'package:chopper/chopper.dart';

part 'main_service.chopper.dart';

@ChopperApi(baseUrl: "/v3/search")
abstract class MainService extends ChopperService {
  static MainService create([ChopperClient? client]) => _$MainService(client);

  @Get(path: "/book?target=title")
  @multipart
  Future<Response> books();
}
