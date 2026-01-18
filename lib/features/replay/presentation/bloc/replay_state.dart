import '../../../domain/replay_state.dart';

abstract class ReplayStatus {}
class ReplayIdle extends ReplayStatus {}
class ReplayPlaying extends ReplayStatus {}
class ReplayPaused extends ReplayStatus {}
class ReplayEnded extends ReplayStatus {}
