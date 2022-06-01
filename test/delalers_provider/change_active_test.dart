import 'package:cvault/providers/dealers_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test to change active status of a dealer', () async {
    final provider = DealersProvider();

    bool success = await provider.changeDealerActiveState('1234');
    expect(success, true);
  });
}
