import 'package:dosis_exacta/viewmodel/home_vm.dart';
import'package:dosis_exacta/viewmodel/remainder_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/theme.dart';

class RemainderList extends StatefulWidget {

  const RemainderList({Key? key}) : super(key: key);

  @override
  State<RemainderList> createState() => _RemainderList();

}

class _RemainderList extends State<RemainderList> {

  bool isLoading = true;
  HomeVM viewModel = HomeVM();
  RemainderVM viewModelRemainder = RemainderVM();
  var remainders = [];
  var user;
  var time = ["8:00","10:15",""].cast<dynamic>();
  var medicine = ["Paracetamol","Luvox","Buscapina"].cast<dynamic>();
  var time_left = ["Cada 8 horas","Cada 12 horas","3 veces al dia"].cast<dynamic>();
  var indications = ["2 tabletas","Media tableta","1 tableta"].cast<dynamic>();
  refreshRemainders() async {
    var updatedRemainders = (await viewModelRemainder.getRemainders())!.cast<dynamic>();
    setState(() {
      remainders = updatedRemainders;
    });
  }

  onClickDelete(int index) async {
    var result = await viewModelRemainder.deleteRemainder(remainders[index]);
    if(result == true) refreshRemainders();
  }

  onClickEdit(int index) async {
    var result = await Navigator.of(context).pushNamed("/contacts/form", arguments: { "remainder": remainders[index] });
    if(result == true) refreshRemainders();
  }
  onClickReturn() {
    Navigator.of(context).pop();
  }
  /*
  onClickEdit() {
    Navigator.of(context).pushNamed("/recordatorio/list");
  }
  onClickDelete(int index) async{
    setState(() {
      medicine.removeAt(index);
      time.removeAt(index);
      time_left.removeAt(index);
      indications.removeAt(index);
    });
  }
  */
  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async{

      user = await viewModel.checkExistingUser();
      await refreshRemainders();
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
                  "Medicamentos",
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
                  itemCount: remainders.length,
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
                                    child: Text(remainders[index].drug.name,style:AppTextTheme.large(),maxLines: 3,
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
                                    child: Text(remainders[index].drug.freq,style:AppTextTheme.small(),maxLines: 3),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.1.sw, 0.005.sh, 0.1.sw, 0.0.sh),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(indications[index],style:AppTextTheme.small(),maxLines: 3,overflow: TextOverflow.clip,),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.1.sw, 0.005.sh, 0.1.sw, 0.0.sh),
                              child: Row(
                                children: [
                                  Padding(
                                      padding:EdgeInsets.fromLTRB(0.003.sw, 0.005.sh, 0.0.sw, 0.0.sh),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 0.3.sw,
                                            child: ElevatedButton(
                                                onPressed: () { onClickEdit(index); },
                                                style: Styles.button(context, color: Color(0xFF7977AA)),
                                                child: Text("Editar",style:AppTextTheme.medium(color: Colors.white))
                                            ),
                                          ),
                                          SizedBox(
                                            width: 0.08.sw,
                                          ),
                                          SizedBox(
                                            width: 0.3.sw,
                                            child: ElevatedButton(
                                                onPressed: (){onClickDelete(index);},
                                                style: Styles.button(context, color: Color(0xFFF44336)),
                                                child: Text("Eliminar",style:AppTextTheme.medium(color: Colors.white))
                                            ),
                                          ),
                                        ],
                                      ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
        )
    );
  }

}