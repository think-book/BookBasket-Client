# BookBasket

## mobile版をweb版にするには
### ファイル名を置き換える
pubspec_web.yaml → pubspec.yaml
pubspec.yaml → pubspec_client.yaml

### dartファイル内の文字を以下のように置き換える
package:flutter → package:flutter_web
dart:ui → package:flutter_web_ui/ui.dart

## web版をmobile版にするには
↑の逆をやる
