import 'package:animate_do/animate_do.dart';
import 'package:dosis_exacta/viewmodel/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/theme.dart';

class RecordatorioMenu extends StatefulWidget {

  const RecordatorioMenu({Key? key}) : super(key: key);

  @override
  State<RecordatorioMenu> createState() => _RecordatorioMenu();

}

class _RecordatorioMenu extends State<RecordatorioMenu> {

  bool isLoading = true;
  HomeVM viewModel = HomeVM();
  var user;
  onClickAddHand (){
    Navigator.of(context).pushNamed("/recordatorio/form");
  }

  onClickPhoto() {
    Navigator.of(context).pushNamed("/recordatorio/photo");
  }

  onClickEdit() {
    Navigator.of(context).pushNamed("/recordatorio/list");
  }

  onClickReturn() {
    Navigator.of(context).pop();
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Editar Recordatorio",
                  style: AppTextTheme.medium(color: Colors.white)
              )
            ],
          ),
        ),
        body: FadeIn(child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 0.20.sh),
              Padding(
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                child: ElevatedButton(
                    onPressed: onClickAddHand,
                    style: Styles.button(context, color: AppColors.primary()),
                    child: Row(
                      children: [
                        SizedBox(width: 20.sp),
                        Icon(Icons.back_hand, color: Colors.white, size: 40.sp),
                        SizedBox(width: 20.sp),
                        Text(
                            "Agregar a mano",
                            style: AppTextTheme.medium(color: Colors.white)
                        ),
                      ],
                    )
                ),
              ),
              SizedBox(height: 0.05.sh),
              Padding(
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                child: ElevatedButton(
                    onPressed: onClickPhoto,
                    style: Styles.button(context, color: AppColors.primary()),
                    child: Row(
                      children: [
                        SizedBox(width: 20.sp),
                        Icon(Icons.camera_alt, color: Colors.white, size: 40.sp),
                        SizedBox(width: 20.sp),
                        Text(
                            "Tomar foto",
                            style: AppTextTheme.medium(color: Colors.white)
                        ),
                      ],
                    )
                ),
              ),
              SizedBox(height: 0.05.sh),
              Padding(
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                child: ElevatedButton(
                    onPressed: onClickEdit,
                    style: Styles.button(context, color: AppColors.primary()),
                    child: Row(
                      children: [
                        SizedBox(width: 20.sp),
                        Icon(Icons.edit_note, color: Colors.white, size: 40.sp),
                        SizedBox(width: 20.sp),
                        Text(
                            "Modificar",
                            style: AppTextTheme.medium(color: Colors.white)
                        ),
                      ],
                    )
                ),
              ),
              SizedBox(height: 0.25.sh),
              Padding(
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                child: ElevatedButton(
                    onPressed: onClickReturn,
                    style: Styles.button(context, color: AppColors.primary()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white, size: 40.sp),
                        SizedBox(width: 20.sp),
                        Text(
                            "Regresar",
                            style: AppTextTheme.medium(color: Colors.white)
                        ),
                        SizedBox(width: 25.sp),
                      ],
                    )
                ),
              ),
            ],
          ),
        ))
    );
  }

}