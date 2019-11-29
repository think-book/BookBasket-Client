import 'package:test/test.dart';
import 'package:bookbasket/forum/thread_list.dart';
import 'package:bookbasket/forum/thread_message.dart';
import 'package:bookbasket/forum/thread_screen.dart';

void main(){
  /**
   *  This test is always true, whatever the main.dart code is.
   */
  group('thread test', (){
    test('thread message from json', (){
      int id = 0;
      String userName = "hello";
      String message = '0123456789';
      var tm = ThreadMessage.fromJson({'id': id, 'userName': userName, 'message': message});
      expect(tm.id, id);
      expect(tm.userName, userName);
      expect(tm.message, message);
    });
  });
}
