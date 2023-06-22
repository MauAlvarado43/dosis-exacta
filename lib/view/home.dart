import 'package:animate_do/animate_do.dart';
import 'package:dosis_exacta/viewmodel/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'common/theme.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => HomeState();

}

class HomeState extends State<Home> {

  bool isLoading = true;
  HomeVM viewModel = HomeVM();
  var user;

  onClickAlerts() {
    Navigator.of(context).pushNamed("/contacts/menu");
  }

  onClickEditRecordatorio(){
    Navigator.of(context).pushNamed("/recordatorio/menu");
  }

  onClickRecordatorio() {
    Navigator.of(context).pushNamed("/recordatorio/home");
  }

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async{

      user = await viewModel.checkExistingUser();

      if(user == null) {
        Navigator.of(context).pushReplacementNamed("/");
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
    return isLoading ? const Scaffold() : Scaffold(
        body: FadeIn(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 0.10.sh),
                Image.asset("assets/images/welcome_logo.png"),
                SizedBox(height: 0.03.sh),
                Text(
                    "Bienvenido " + user.name,
                    style: AppTextTheme.large(),
                    textAlign: TextAlign.center
                ),
                SizedBox(height: 0.03.sh),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                  child: ElevatedButton(
                      onPressed: onClickEditRecordatorio,
                      style: Styles.button(context, color: AppColors.primary()),
                      child: Row(
                        children: [
                          SizedBox(width: 20.sp),
                          Icon(Icons.edit, color: Colors.white, size: 40.sp),
                          SizedBox(width: 20.sp),
                          Text(
                              "Editar recordatorios",
                              style: AppTextTheme.medium(color: Colors.white)
                          ),
                        ],
                      )
                  ),
                ),
                SizedBox(height: 0.03.sh),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                  child: ElevatedButton(
                      onPressed: onClickRecordatorio,
                      style: Styles.button(context, color: AppColors.primary()),
                      child: Row(
                        children: [
                          SizedBox(width: 20.sp),
                          Icon(Icons.alarm, color: Colors.white, size: 40.sp),
                          SizedBox(width: 20.sp),
                          Text(
                              "Recordatorios",
                              style: AppTextTheme.medium(color: Colors.white)
                          ),
                        ],
                      )
                  ),
                ),
                SizedBox(height: 0.03.sh),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                  child: ElevatedButton(
                      onPressed: onClickAlerts,
                      style: Styles.button(context, color: AppColors.primary()),
                      child: Row(
                        children: [
                          SizedBox(width: 20.sp),
                          Icon(Icons.notification_important, color: Colors.white, size: 40.sp),
                          SizedBox(width: 20.sp),
                          Text(
                              "Alertas",
                              style: AppTextTheme.medium(color: Colors.white)
                          ),
                        ],
                      )
                  ),
                ),
                SizedBox(height: 0.03.sh),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                  child: ElevatedButton(
                      onPressed: () {},
                      style: Styles.button(context, color: AppColors.primary()),
                      child: Row(
                        children: [
                          SizedBox(width: 20.sp),
                          Icon(Icons.check, color: Colors.white, size: 40.sp),
                          SizedBox(width: 20.sp),
                          Text(
                              "Disponibilidad",
                              style: AppTextTheme.medium(color: Colors.white)
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

}