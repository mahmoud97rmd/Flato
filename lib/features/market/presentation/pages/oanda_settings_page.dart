import 'package:flutter/material.dart';
import '../../domain/usecases/save_oanda_credentials.dart';
import '../../domain/usecases/get_available_instruments.dart';
import '../../domain/usecases/get_saved_credentials.dart';
import '../../domain/repositories/market_repository.dart';
import '../widgets/instrument_list_widget.dart';

class OandaSettingsPage extends StatefulWidget {
  final MarketRepository repository;

  OandaSettingsPage({required this.repository});

  @override
  _OandaSettingsPageState createState() => _OandaSettingsPageState();
}

class _OandaSettingsPageState extends State<OandaSettingsPage> {
  final _tokenController = TextEditingController();
  final _accountIdController = TextEditingController();

  bool _isLoading = false;
  List<String> _instruments = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    try {
      final credentials = await GetSavedCredentials(widget.repository)();
      _tokenController.text = credentials['token']!;
      _accountIdController.text = credentials['accountId']!;
      _fetchInstruments(); // جلب تلقائي
    } catch (_) {}
  }

  void _saveCredentials() async {
    setState(() => _isLoading = true);
    await SaveOandaCredentials(widget.repository)(
      token: _tokenController.text.trim(),
      accountId: _accountIdController.text.trim(),
    );
    await _fetchInstruments();
    setState(() => _isLoading = false);
  }

  void _fetchInstruments() async {
    setState(() => _isLoading = true);
    final list = await GetAvailableInstruments(widget.repository)();
    setState(() => _instruments = list);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إعدادات OANDA")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                labelText: "API Token",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _accountIdController,
              decoration: InputDecoration(
                labelText: "Account ID",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveCredentials,
              child: Text("حفظ وجلب الأسواق"),
            ),
            SizedBox(height: 16),
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading && _instruments.isNotEmpty)
              Expanded(child: InstrumentListWidget(instruments: _instruments)),
          ],
        ),
      ),
    );
  }
}
