# BookBasket
## mobile版をweb版にするには
### ファイル名を置き換える
pubspec_web.yaml → pubspec.yaml

pubspec.yaml → pubspec_mobile.yaml

### dartファイル内の文字を以下のように置き換える
package:flutter → package:flutter_web

dart:ui → package:flutter_web_ui/ui.dart

## web版をmobile版にするには
↑の逆をやる

## mobile版実行方法
[iOS](https://flutter.dev/docs/get-started/install/macos#ios-setup)

[Android](https://flutter.dev/docs/get-started/install/macos#android-setup)

## web版実行方法
https://flutter.dev/docs/get-started/web   
  

10/1 加筆  
1) go の feature/xplatform-access をpullしdocker-compose build して up  
2) flutter の webdev ブランチをpull して  
```
$ flutter channel master   
$ flutter upgrade   
$ flutter config --enable-web   
$ flutter run -d chrome   
```  
でたち上がる。　　