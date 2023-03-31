import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextTheme {

  static large({ Color? color }) => TextStyle(
      color: color??Colors.black,
      fontSize: 24.sp,
      fontWeight: FontWeight.bold
  );

  static medium({ Color? color }) => TextStyle(
      color: color??Colors.black,
      fontSize: 18.sp
  );

  static small({ Color? color }) => TextStyle(
      color: color??Colors.black,
      fontSize: 12.sp
  );

}

class AppColors {

  static primary() => const Color(0xFF3F88C5);
  static secondary() => const Color(0xFF44BBA4);
  static accent() => const Color(0xFF7977AA);
  static danger() => const Color(0xFFF44336);

}

class Styles {

  static button(context, {required Color color}) => ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(color),
    elevation: MaterialStateProperty.all<double>(10),
    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(5.sp)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.sp),
      ),
    ),
  );

  static input(context, {required TextEditingController controller, String? hint, RegExp? validation}) => InputDecoration(
      filled: controller.text.isNotEmpty,
      border: InputBorder.none,
      hintText: hint,
      contentPadding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 10.sp),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.sp),
        borderRadius: BorderRadius.circular(10.0.sp),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.sp),
        borderRadius: BorderRadius.circular(10.0.sp),
      ),
      suffixIcon: () {
        var validate = true;
        if(validation != null) validate = validation.hasMatch(controller.text);
        return controller.text.isNotEmpty && validate
            ? Icon(Icons.check, color: Theme.of(context).accentColor)
            : const SizedBox();
      } ()

  );

}

var THEME = ThemeData(
    highlightColor: const Color(0xFFF44336),
    fontFamily: 'Arial',
    colorScheme: ColorScheme.fromSwatch().copyWith(
      background: const Color(0xFFFFFFFF)
    ),
);
