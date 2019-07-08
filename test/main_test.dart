import 'package:test/test.dart';
import 'package:bookbasket/main.dart';

void main(){
  group('example test group', (){
    test('example test', (){
      var a = 1, b = 2;

      expect(a+b, 3);

    } );
  });

  test('Post object must be created.', () {
    final post = Post();

    expect(post != null, true);
  });

}
