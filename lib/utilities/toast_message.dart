import 'package:fluttertoast/fluttertoast.dart';
import 'package:locainfo/constants/app_colors.dart';

// Function to show toast message
void showToastMessage(String message) => Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      textColor: AppColors.darkerBlue,
      fontSize: 14,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.grey3,
    );
