import 'dart:math';

import 'package:dosis_exacta/viewmodel/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/theme.dart';

class RemainderHome extends StatefulWidget {

  const RemainderHome({Key? key}) : super(key: key);

  @override
  State<RemainderHome> createState() => _RemainderHome();

}


class _RemainderHome extends State<RemainderHome> {

  bool isLoading = true;
  HomeVM viewModel = HomeVM();
  var user;


  var time = ["18:15","1/3","19:23"];
  var medicine = ["Paracetamol","Luvox","Buscapina"];
  var time_left = ["Dentro de 2 horas","en 10 minutos","Dentro de 3 minutos"];
  var indication = ["2 tabletas","Media tableta","1 tableta"];

  var shown = [0,0,0];

  onClickEdit() {
    Navigator.of(context).pushNamed("/recordatorio/list");
  }

  onClickReturn() {
    Navigator.of(context).pop();
  }

  onClickingested(int index){
    shown[index] = 1;
  }

  refreshRemainders() async{
    setState(() {
      for(var i = 0; i<medicine.length;i++){
        if(shown[i]==1){
          medicine.removeAt(i);
          time.removeAt(i);
          time_left.removeAt(i);
          indication.removeAt(i);
          shown.removeAt(i);
        }
      }
    });
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
                  "Recordatorio",
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
              SizedBox(height: 0.01.sh),
              SizedBox(
                height: 0.70.sh,
                child: ListView.builder(
                  itemCount: medicine.length,
                  itemBuilder: (context,index){
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0.03.sw, 0, 0.03.sw, 0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.1.sw, 0.02.sh, 0.1.sw, 0.0.sh),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(medicine[index],style:AppTextTheme.large(),maxLines: 3,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  child: Text(time[index],style:AppTextTheme.small()),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.1.sw, 0.005.sh, 0.1.sw, 0.0.sh),
                            child: Row(
                              children: [
                                SizedBox(
                                  child: Text(time_left[index],style:AppTextTheme.small(),maxLines: 3),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.1.sw, 0.005.sh, 0.1.sw, 0.0.sh),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(indication[index],style:AppTextTheme.small(),maxLines: 3,overflow: TextOverflow.clip,),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.1.sw, 0.005.sh, 0.1.sw, 0.0.sh),
                            child: SizedBox(
                              width: 0.55.sw,
                              child: ElevatedButton(
                                onPressed: (){
                                  onClickingested(index);
                                  refreshRemainders();
                                },
                                style: Styles.button(context, color: Color(0xFF44BBA4)),
                                child: Text("Dosis ingerida",style:AppTextTheme.medium(color: Colors.white)),

                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                  },
                ),
              ),

              SizedBox(height: 0.03.sh),
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