import 'package:dosis_exacta/view/common/theme.dart';
import 'package:dosis_exacta/viewmodel/welcome_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Welcome extends StatefulWidget {
  
  @override
  State<Welcome> createState() => _WelcomeState();
  
}

class _WelcomeState extends State<Welcome> {

  bool isLoading = true;
  bool showValidation = false;
  WelcomeVW viewModel = WelcomeVW();

  final TextEditingController _nameController = TextEditingController();

  onClickStart() {

    bool result = viewModel.registerUser(_nameController.text);

    if(result) {
      Navigator.of(context).pushReplacementNamed("/home");
    }
    else {
      setState(() {
        showValidation = true;
      });
    }

  }

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async{

      var user = await viewModel.checkExistingUser();

      if(user != null) {
        Navigator.of(context).pushReplacementNamed("/home");
      }
      else {
        setState(() {
          isLoading = false;
        });
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const  Scaffold() : Scaffold(
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
            SizedBox(height: 0.05.sh),
            showValidation
              ?  Text(
                "Ingresa tu nombre para poder comenzar",
                style: AppTextTheme.medium(color: Colors.redAccent)
              )
              : Container(),
            showValidation
              ? SizedBox(height: 0.05.sh)
              : Container(),
            Padding(
              padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
              child: ElevatedButton(
                  onPressed: onClickStart,
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