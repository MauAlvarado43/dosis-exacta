import 'package:dosis_exacta/viewmodel/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/theme.dart';

class ContactMenu extends StatefulWidget {

  const ContactMenu({Key? key}) : super(key: key);

  @override
  State<ContactMenu> createState() => _ContactMenuState();

}

class _ContactMenuState extends State<ContactMenu> {

  bool isLoading = true;
  HomeVM viewModel = HomeVM();
  var user;

  onClickAdd() {
    Navigator.of(context).pushNamed("/contacts/form");
  }

  onClickEdit() {
    Navigator.of(context).pushNamed("/contacts/list");
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
                "Alertas",
                style: AppTextTheme.medium(color: Colors.white)
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 0.25.sh),
              Padding(
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                child: ElevatedButton(
                    onPressed: onClickAdd,
                    style: Styles.button(context, color: AppColors.primary()),
                    child: Row(
                      children: [
                        SizedBox(width: 20.sp),
                        Icon(Icons.add, color: Colors.white, size: 40.sp),
                        SizedBox(width: 20.sp),
                        Text(
                            "Añadir contacto",
                            style: AppTextTheme.medium(color: Colors.white)
                        ),
                      ],
                    )
                ),
              ),
              SizedBox(height: 0.07.sh),
              Padding(
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                child: ElevatedButton(
                    onPressed: onClickEdit,
                    style: Styles.button(context, color: AppColors.primary()),
                    child: Row(
                      children: [
                        SizedBox(width: 20.sp),
                        Icon(Icons.edit, color: Colors.white, size: 40.sp),
                        SizedBox(width: 20.sp),
                        Text(
                            "Editar contacto",
                            style: AppTextTheme.medium(color: Colors.white)
                        ),
                      ],
                    )
                ),
              ),
              SizedBox(height: 0.30.sh),
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
        )
    );
  }

}