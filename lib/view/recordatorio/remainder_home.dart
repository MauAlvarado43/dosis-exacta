import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:dosis_exacta/viewmodel/home_vm.dart';
import 'package:dosis_exacta/viewmodel/remainder_vm.dart';
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
  RemainderVM viewModel = RemainderVM();
  var remainders;

  onClickReturn() {
    Navigator.of(context).pop();
  }

  onClickIngested(int index) async {
    viewModel.checkIngestedRemainder(remainders[index]);
    remainders = await viewModel.getActiveRemainders();
    setState(() { remainders = remainders; });
  }

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async{

      remainders = await viewModel.getActiveRemainders();

      if(remainders == null) {
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
        body: FadeIn(child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 0.01.sh),
              SizedBox(
                height: 0.70.sh,
                child: ListView.builder(
                  itemCount: remainders != null ? remainders.length : 0,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(remainders[index].drug.name,style:AppTextTheme.large(),maxLines: 3,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  Container(
                                    child: Text((){

                                      int hour = remainders[index].date.hour;
                                      int minute = remainders[index].date.minute;
                                      String suffix = "";

                                      if(hour < 12) {
                                        suffix = "a.m.";
                                      }
                                      else {
                                        hour -= 12;
                                        suffix = "p.m.";
                                      }

                                      String date = (hour < 10) ? "0" + hour.toString() + ":" : hour.toString() + ":";
                                      if(minute < 10) date = (minute < 10) ? date + "0" + minute.toString() : date + minute.toString();

                                      return date + " " + suffix;

                                    }(),style:AppTextTheme.small()),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.1.sw, 0.005.sh, 0.1.sw, 0.0.sh),
                              child: Row(
                                children: [
                                  SizedBox(
                                    child: Text(
                                            (){

                                          var difference = DateTime.now().difference(remainders[index].date);
                                          String preffix = "";
                                          String amount = "";
                                          String suffix = "";

                                          if(difference.isNegative) {

                                            if(difference.inMinutes.abs() >= 60) {

                                              amount = difference.inHours.abs().toString();

                                              if(difference.inHours.abs() > 1) {
                                                preffix = "Faltan "; suffix = " horas";
                                              }
                                              else {
                                                preffix = "Falta "; suffix = " hora";
                                              }

                                            }
                                            else {

                                              amount = difference.inMinutes.abs().toString();


                                              if(difference.inMinutes.abs() > 1) {
                                                preffix = "Faltan "; suffix = " minutos";
                                              }
                                              else if(difference.inMinutes.abs() == 1) {
                                                preffix = "Falta "; suffix = " minuto";
                                              }
                                              else {
                                                preffix = "Justo Ahora";
                                              }

                                            }

                                          }
                                          else {

                                            if(difference.inMinutes.abs() >= 60) {

                                              amount = difference.inHours.toString();

                                              if(difference.inHours.abs() > 1) {
                                                preffix = "Hace "; suffix = " horas";
                                              }
                                              else {
                                                preffix = "Hace "; suffix = " hora";
                                              }

                                            }
                                            else {

                                              amount = difference.inMinutes.abs().toString();

                                              if(difference.inMinutes.abs() > 1) {
                                                preffix = "Hace "; suffix = " minutos";
                                              }
                                              else if(difference.inMinutes.abs() == 1) {
                                                preffix = "Hace "; suffix = " minuto";
                                              }
                                              else {
                                                preffix = "Justo Ahora";
                                              }

                                            }

                                          }

                                          return preffix + amount + suffix;

                                        }(),
                                        style: AppTextTheme.small(color: DateTime.now().difference(remainders[index].date).isNegative ? Colors.black : Colors.redAccent),
                                        maxLines: 3
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.1.sw, 0.005.sh, 0.1.sw, 0.0.sh),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(remainders[index].drug.indications, style:AppTextTheme.small(), maxLines: 3, overflow: TextOverflow.clip),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.1.sw, 0.005.sh, 0.1.sw, 0.02.sh),
                              child: SizedBox(
                                width: 0.55.sw,
                                child: ElevatedButton(
                                  onPressed: (){
                                    onClickIngested(index);
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
        ))
    );
  }

}