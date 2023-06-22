import 'package:animate_do/animate_do.dart';
import 'package:dosis_exacta/utils/constants.dart';
import 'package:dosis_exacta/viewmodel/drug_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/theme.dart';

class RemainderList extends StatefulWidget {

  const RemainderList({Key? key}) : super(key: key);

  @override
  State<RemainderList> createState() => _RemainderList();

}

class _RemainderList extends State<RemainderList> {

  bool isLoading = true;
  DrugVM viewModel = DrugVM();
  var user;
  var drugs = [];
  var TimeOrPill = [];
  var timeLeft = [];

  refreshDrugs() async {
    var updateDrugs = (await viewModel.getDrugs())!.cast<dynamic>();
    var updateTimeOrPill = [];
    var updateTimeLeft = [];

    setState(() {

      drugs = updateDrugs;

      for(int i = 0; i < drugs.length ; i++) {

        if(drugs[i].freq_type == FREQ_TYPE.DAILY) {
          updateTimeOrPill.add(drugs[i].freq.toString() + " por día");
        }
        else{
          updateTimeOrPill.add("Cada " + drugs[i].freq.toString() + " horas"); //cambiar a interval
        }

        if(drugs[i].duration == DURATION.DAILY) {
          updateTimeLeft.add("Por " + drugs[i].days.toString() + " días");
        }
        else{
          updateTimeLeft.add("Sin tiempo límite");
        }

      }

      TimeOrPill = updateTimeOrPill;
      timeLeft = updateTimeLeft;

    });
  }

  onClickAddHand (int index) async{
    var result = await Navigator.of(context).pushNamed("/recordatorio/form",arguments: {"drug":drugs[index] });
    if(result == true) refreshDrugs();
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

  onClickDelete(int index) async{
    var result = await viewModel.deleteDrug(drugs[index]);
    if(result == true) refreshDrugs();

  }

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async{
      await refreshDrugs();
      setState(() {
        isLoading = false;
      });
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
                  "Medicamentos",
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
              drugs.length > 0
                ? SizedBox(
                height: 0.70.sh,
                child: ListView.builder(
                  itemCount: drugs.length,
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
                                    child: Text(drugs[index].name,style:AppTextTheme.large(),maxLines: 3,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  Text(timeLeft[index],style:AppTextTheme.small())
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.1.sw, 0.005.sh, 0.1.sw, 0.0.sh),
                              child: Row(
                                children: [
                                  SizedBox(
                                    child: Text(TimeOrPill[index],style:AppTextTheme.small(),maxLines: 3),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.1.sw, 0.005.sh, 0.1.sw, 0.0.sh),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(drugs[index].indications,style:AppTextTheme.small(),maxLines: 3,overflow: TextOverflow.clip,),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.1.sw, 0.005.sh, 0.1.sw, 0.02.sh),
                              child: Padding(
                                padding:EdgeInsets.fromLTRB(0.003.sw, 0.005.sh, 0.0.sw, 0.0.sh),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 0.3.sw,
                                      child: ElevatedButton(
                                          onPressed: (){ onClickAddHand(index); },
                                          style: Styles.button(context, color: Color(0xFF7977AA)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.edit, color: Colors.white,),
                                              const SizedBox(width: 5),
                                              Text("Editar",style:AppTextTheme.medium(color: Colors.white))
                                            ],
                                          )
                                      ),
                                    ),
                                    SizedBox(
                                      width: 0.3.sw,
                                      child: ElevatedButton(
                                          onPressed: (){ onClickDelete(index); },
                                          style: Styles.button(context, color: Color(0xFFF44336)),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.delete, color: Colors.white,),
                                              const SizedBox(width: 5),
                                              Text("Eliminar",style:AppTextTheme.medium(color: Colors.white))
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
                : SizedBox(
                  height: 0.7.sh,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 0.03.sh),
                      Image.asset("assets/images/no_drugs.png"),
                      SizedBox(height: 0.03.sh),
                      Text(
                        "Aún no tienes medicamentos registrados",
                        style: AppTextTheme.medium(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 0.03.sh),
                      SizedBox(height: 0.03.sh),
                    ],
                  )
              ),
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