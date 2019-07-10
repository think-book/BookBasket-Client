import 'package:test/test.dart';
import 'package:bookbasket/main.dart';

void main(){
  /**
   *  This test is always true, whatever the main.dart code is.
   */
  group('example test group', (){
    test('example test', (){
      var a = 1, b = 2;

      expect(a+b, 3);

    } );
  });

  /**
   * Sample test:
  test('Post object must be created.', () {
    final post = Post();

    expect(post != null, true);
  });

  */
}
