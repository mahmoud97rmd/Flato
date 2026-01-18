typedef WebhookHandlerFunc = Future<void> Function(Map<String, dynamic>);

class WebhookHandler {
  final Map<String, WebhookHandlerFunc> handlers = {};

  void register(String event, WebhookHandlerFunc fn) => handlers[event] = fn;

  Future<void> handle(String event, Map<String, dynamic> body) async {
    if (handlers.containsKey(event)) await handlers[event]!(body);
  }
}
