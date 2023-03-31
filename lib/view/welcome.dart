import 'package:dosis_exacta/view/common/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Welcome extends StatefulWidget {
  
  @override
  State<Welcome> createState() => _WelcomeState();
  
}

class _WelcomeState extends State<Welcome> {

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 0.10.sh),
            Image.asset("assets/images/welcome_logo.png"),
            SizedBox(height: 0.03.sh),
            Text(
              "Empieza ahora mismo \n en Dosis Exacta",
              style: AppTextTheme.large(),
              textAlign: TextAlign.center
            ),
            SizedBox(height: 0.10.sh),
            Text(
              "Solo ingresa tu nombre",
              style: AppTextTheme.medium()
            ),
            SizedBox(height: 0.02.sh),
            Padding(
              padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
              child: TextField(
                controller: _nameController,
                decoration: Styles.input(context, controller: _nameController),
              ),
            ),
            SizedBox(height: 0.10.sh),
            Padding(
              padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
              child: ElevatedButton(
                  onPressed: () {},
                  style: Styles.button(context, color: AppColors.primary()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white, size: 40.sp),
                      SizedBox(width: 10.sp),
                      Text(
                        "Empezar",
                        style: AppTextTheme.medium(color: Colors.white)
                      )
                    ],
                  )
              ),
            )
          ],
        ),
      )
    );
  }

}