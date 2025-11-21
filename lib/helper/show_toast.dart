import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShowToast {
  static showToast(String message, {EasyLoadingToastPosition position = EasyLoadingToastPosition.bottom}) {
    EasyLoading.showToast(message, toastPosition: position);
  }
}
