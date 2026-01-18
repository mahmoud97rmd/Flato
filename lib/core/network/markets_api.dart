import 'rest_client.dart';
import '../models/dto/instrument_dto.dart';

class MarketsApi {
  final RestClient client;

  MarketsApi(this.client);

  Future<List<InstrumentDto>> fetchAll() async {
    final res = await client.get("/instruments");
    return (res['instruments'] as List)
        .map((j) => InstrumentDto.fromJson(j))
        .toList();
  }
}
