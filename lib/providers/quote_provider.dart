import 'package:cvault/models/transaction.dart';

import 'package:flutter/cupertino.dart';

class QuoteProvider extends ChangeNotifier {
  Transaction transaction = Transaction.fromJson({});
}
