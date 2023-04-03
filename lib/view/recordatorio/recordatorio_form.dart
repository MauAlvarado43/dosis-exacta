import 'package:dosis_exacta/viewmodel/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/theme.dart';

class RecordatorioForm extends StatefulWidget {
  const RecordatorioForm({Key? key}) : super(key: key);

  @override
  State<RecordatorioForm> createState() => _RecordatorioForm();
}

class _RecordatorioForm extends State<RecordatorioForm> {
  bool isLoading = true;
  HomeVM viewModel = HomeVM();
  var user;
  String? _selectedOption;
  String? _selectedHour;
  String? _selectedInterval;
  String? _selectedDuration;
  String? _selectedTimes;
  String? _selectedDays;

  final List<String> _options = ['Dosis Diaria', 'Horas'];
  final List<String> _timesForDay = ['1 vez al día', '2 veces al día', '3 veces al día', '4 veces al día', '6 veces al día'];
  final List<String> _hours = [
    '1:00 am',
    '2:00am',
    '3:00am',
    '4:00am',
    '5:00am',
    '6:00am',
    '7:00am',
    '8:00am',
    '9:00am',
    '10:00am',
    '11:00am',
    '12:00pm',
    '1:00pm',
    '2:00pm',
    '3:00pm',
    '4:00pm',
    '5:00pm',
    '6:00pm',
    '7:00pm',
    '8:00pm',
    '9:00pm',
    '10:00pm',
    '11:00pm',
    '12:00am'
  ];
  final List<String> _days = ['1 día', '2 días', '3 días', '4 días', '5 días', '6 días', '7 días', '8 días', '9 días', '10 días'];
  final List<String> _intervals = [
    '4 horas',
    '8 horas',
    '12 horas',
    '16 horas',
    '24 horas'
  ];
  final List<String> _durations = ['Días', 'Siempre'];

  onClickAddHand() {
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
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      user = await viewModel.checkExistingUser();
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("/");
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Detalles", style: AppTextTheme.medium(color: Colors.white))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 0.06.sh),
            Padding(
              padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    SizedBox(
                      height: 0.03.sh,
                    ),


                    //SELECT FREQUENCY
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                          child:
                              Text("Frecuencia", style: AppTextTheme.medium()),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 300.0,
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: DropdownButton<String>(
                            hint: Text('  Selecciona una opción...        '),
                            value: _selectedOption,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24.0,
                            elevation: 15,
                            style: TextStyle(
                                color: Colors.black, fontSize: 0.025.sh),
                            underline: Container(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedOption = newValue!;
                              });
                            },
                            items: _options
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    _selectedOption == 'Dosis Diaria'
                        ? Row(
                            children: [
                              Container(
                                width: 300.0,
                                margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  hint: Text('  Selecciona una opción...       '),
                                  value: _selectedTimes,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24.0,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 0.025.sh),
                                  underline: Container(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedTimes = newValue!;
                                    });
                                  },
                                  items: _timesForDay
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                      _selectedOption == "Horas"
                        ? Row(
                        children: [
                          Container(
                            width: 140.0,
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: DropdownButton<String>(
                              hint: Text('   Hora               '),
                              value: _selectedHour,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 23.0,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 0.020.sh),
                              underline: Container(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedHour = newValue!;
                                });
                              },
                              items: _hours
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                          Container(
                            width: 140.0,
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: DropdownButton<String>(
                              hint: Text('   Periodo          '),
                              value: _selectedInterval,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 23.0,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 0.020.sh),
                              underline: Container(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedInterval = newValue!;
                                });
                              },
                              items: _intervals
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(value),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ) : Container(),


                    //SELECT FOR DURATION
                    SizedBox(
                      height: 0.025.sh,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                          child:
                          Text("Duración", style: AppTextTheme.medium()),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 300.0,
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: DropdownButton<String>(
                            hint: Text('  Selecciona una opción...        '),
                            value: _selectedDuration,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24.0,
                            elevation: 15,
                            style: TextStyle(
                                color: Colors.black, fontSize: 0.025.sh),
                            underline: Container(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedDuration = newValue!;
                              });
                            },
                            items: _durations
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    _selectedDuration == 'Días'
                        ? Row(
                          children: [
                            Container(
                              width: 300.0,
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: DropdownButton<String>(
                                hint: Text('  Selecciona una opción...       '),
                                value: _selectedDays,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24.0,
                                elevation: 16,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 0.025.sh),
                                underline: Container(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDays = newValue!;
                                  });
                                },
                                items: _days
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(value),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ) :
                              Container(),

                    //INPUT FOR INDICATIONS
                    SizedBox(
                      height: 0.025.sh,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                          child:
                          Text("Indicaciones", style: AppTextTheme.medium()),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 300.0,
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: TextField(
                            maxLines:3,
                            decoration: InputDecoration(
                              hintText: "Ingresar indicaciones adicionales",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.01.sh),
                  ],
                ),
              ),
            ),
            SizedBox(height: 0.04.sh),
            Padding(
              padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
              child: ElevatedButton(
                  onPressed: onClickReturn,
                  style: Styles.button(context, color: AppColors.primary()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back,
                          color: Colors.white, size: 40.sp),
                      SizedBox(width: 20.sp),
                      Text("Regresar",
                          style: AppTextTheme.medium(color: Colors.white)),
                      SizedBox(width: 25.sp),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}