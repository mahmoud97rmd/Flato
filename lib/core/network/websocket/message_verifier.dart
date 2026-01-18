class MessageVerifier {
  int? lastId;

  bool isInOrder(int newId) {
    if (lastId == null) {
      lastId = newId;
      return true;
    }

    if (newId > lastId!) {
      lastId = newId;
      return true;
    }

    return false; // out-of-order
  }
}
