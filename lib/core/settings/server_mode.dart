enum ServerMode { sandbox, live }

extension ServerModeExt on ServerMode {
  String get name => this == ServerMode.sandbox ? "SANDBOX" : "LIVE";
}
