import 'package:dosis_exacta/viewmodel/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dosis_exacta/viewmodel/remainder_vm.dart';
import '../common/theme.dart';
import 'package:dosis_exacta/model/drug.dart';
import 'package:dosis_exacta/utils/constants.dart';

class RecordatorioForm extends StatefulWidget {
  const RecordatorioForm({Key? key}) : super(key: key);

  @override
  State<RecordatorioForm> createState() => _RecordatorioForm();
}

class _RecordatorioForm extends State<RecordatorioForm> {
  final List<String> _options = ['Dosis Diaria', 'Horas'];
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
  final List<String> _timesForDay = ['1 vez al día', '2 veces al día', '3 veces al día', '4 veces al día', '6 veces al día'];
  final List<String> _days = ['1 día', '2 días', '3 días', '4 días', '5 días', '6 días', '7 días', '8 días', '9 días', '10 días'];
  final List<String> _intervals = [
    '4 horas',
    '8 horas',
    '12 horas',
    '16 horas',
    '24 horas'
  ];
  final List<String> _durations = ['Días', 'Siempre'];

  bool isLoading = true;
  HomeVM viewModel = HomeVM();
  var user;
  late String _selectedOption = _options.first;
  late String _selectedHour = _hours.first;
  late String _selectedInterval = _intervals.first;
  late String _selectedDuration = _durations.first;
  late String _selectedTimes = _timesForDay.first;
  late String _selectedDays = _days.first;
  //int times = _timesForDay.indexWhere((element) => element.allMatches(_selectedTimes.text));
  //final TextEditingController _selectedTimes = TextEditingController();
  //final TextEditingController _selectedOption = TextEditingController();
  //final TextEditingController _selectedDuration = TextEditingController();

  final TextEditingController _selectedName = TextEditingController();
  final TextEditingController _ingestedController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _drugController = TextEditingController();
  RemainderVM viewModelRemainder = RemainderVM();
  var remainder;
  onClickSave() async {
    bool result = false;
    if (remainder == null) {
      result = await viewModelRemainder.createRemainder(
          ingested: true,
          date: DateTime.now(),
          drug: Drug(name: _selectedName.text,freq_type: frecuency_typeGet(_selectedOption),duration: duration_typeGet(_selectedDuration),freq: frecuencyget(_selectedInterval),start_hour: _selectedHour));
          Navigator.of(context).pushNamed("/recordatorio/list");
    } else {
      result = await viewModelRemainder.updateRemainder(remainder,
          //ingested: _ingestedController.text,
          //date: _dateController.text,
          //drug: _drugController.text);
          ingested: false,
          date: DateTime.now(),
          drug: Drug(name: _selectedName.text,freq_type: frecuency_typeGet(_selectedOption),duration: duration_typeGet(_selectedDuration),freq: frecuencyget(_selectedInterval),start_hour: _selectedHour));
          Navigator.of(context).pushNamed("/recordatorio/list");
    }
    if (result) {
      Navigator.of(context).pop(true);
    }
  }

  frecuencyget(_selectedInterval){
    switch(_selectedInterval) {
      case '4 horas': {return 4;}
      case '8 horas': {return 8;}
      case '12 horas': {return 12;}
      case '16 horas': {return 16;}
      default: {return 24;}
    }
  }

  frecuency_typeGet(_selectedOption){
    switch(_selectedOption) {
      case 'Dosis Diaria': {return FREQ_TYPE.DAILY;}
      default: {return FREQ_TYPE.HOUR;}
    }
  }
  duration_typeGet(_selectedDuration){
    switch(_selectedDuration) {
      case 'Días': {return DURATION.DAILY;}
      case 'Siempre': {return DURATION.FOREVER;}
      default: {return DURATION.TEMPORARY;}
    }
  }

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
    Map<String, dynamic>? args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args["remainder"] != null) {
      setState(() {
        remainder = args["remainder"];
        _ingestedController.text = remainder.ingested;
        _dateController.text = remainder.date;
        _drugController.text = remainder.drug;
      });
    }
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
                    // SET NAME DRUG
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                          child:
                          Text("Nombre", style: AppTextTheme.medium()),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 0.37.sh,
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: TextField(
                            controller: _selectedName,
                            decoration: InputDecoration(
                              hintText: "Nombre Medicina",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.01.sh),
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
                          width: 0.37.sh,
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
                            onChanged: (String? changedValue) {
                              _selectedOption = changedValue!;
                              setState(() {
                                _selectedOption;
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
                                width: 0.37.sh,
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
                                    _selectedTimes = newValue!;
                                    setState(() {
                                      _selectedTimes;
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
                            width: 0.175.sh,
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
                                _selectedHour = newValue!;
                                setState(() {
                                  _selectedHour;
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
                            width: 0.175.sh,
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
                                _selectedInterval = newValue!;
                                setState(() {
                                  _selectedInterval;
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
                          width: 0.37.sh,
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
                              _selectedDuration = newValue!;
                              setState(() {
                                _selectedDuration;
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
                              width: 0.37.sh,
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
                                  _selectedDays = newValue!;
                                  setState(() {
                                    _selectedDays;
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
                          width: 0.37.sh,
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
                  onPressed: onClickSave,
                  style: Styles.button(context, color: AppColors.primary()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.plus_one,
                          color: Colors.white, size: 40.sp),
                      SizedBox(width: 20.sp),
                      Text("Agregar",
                          style: AppTextTheme.medium(color: Colors.white)),
                      SizedBox(width: 25.sp),
                    ],
                  )),
            ),
            SizedBox(height: 0.04.sh),
            Padding(
              padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
              child: ElevatedButton(
                  onPressed: onClickReturn,
                  style: Styles.button(context, color: AppColors.secondary()),
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