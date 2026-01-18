import '../../../core/utils/secure_storage.dart';

class LocalStorage {
  Future<void> saveOandaCredentials({
    required String apiToken,
    required String accountId,
  }) async {
    await SecureStorage.saveCredentials(
      apiToken: apiToken,
      accountId: accountId,
    );
  }

  Future<Map<String, String>?> getOandaCredentials() async {
    return await SecureStorage.readCredentials();
  }

  Future<void> clearOandaCredentials() async {
    await SecureStorage.clearCredentials();
  }
}
