import 'package:dosis_exacta/view/common/theme.dart';
import 'package:dosis_exacta/view/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {

  const App({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () =>
          MaterialApp(
            builder: (context, widget) {
              ScreenUtil.setContext(context);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
            theme: THEME,
            routes: ROUTER,
            initialRoute: '/',
          ),
    );

  }

}