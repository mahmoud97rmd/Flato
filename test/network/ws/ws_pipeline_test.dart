import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/core/network/ws/pipeline/ws_pipeline.dart';

void main() {
  test("Pipeline buffers and emits in order", () {
    final pipeline = WsPipeline(maxBufferSize: 3);
    final events = [];

    pipeline.stream.listen((data) {
      events.add(data);
    });

    pipeline.push(1);
    pipeline.push(2);
    pipeline.push(3);

    expect(events, [1, 2, 3]);
  });
}
