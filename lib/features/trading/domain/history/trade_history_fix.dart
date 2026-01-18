import '../order/order.dart';
import '../../../../../core/storage/audit/event_audit_manager3.dart';

class TradeHistoryFix {
  static void recordUpdate(Order order, String note) {
    EventAuditManager3.log("TradeUpdate: ${order.id} | $note");
  }
}
