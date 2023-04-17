import 'package:dosis_exacta/utils/constants.dart';
import 'package:dosis_exacta/viewmodel/drug_vm.dart';
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
  DrugVM viewModel = DrugVM();
  var user;
  var drug;
  String? _selectedOption;
  String? _selectedHour;
  String? _selectedInterval;
  String? _selectedDuration;
  String? _selectedTimes;
  String? _selectedDays;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _indicationsController = TextEditingController();

  final List<String> _options = ['Dosis Diaria', 'Horas'];
  final List<String> _timesForDay = [
    '1 vez al día',
    '2 veces al día',
    '3 veces al día',
    '4 veces al día',
    '5 veces al día'
  ];
  final List<String> _hours = [
    '00:00 am',
    '01:00 am',
    '02:00 am',
    '03:00 am',
    '04:00 am',
    '05:00 am',
    '06:00 am',
    '07:00 am',
    '08:00 am',
    '09:00 am',
    '10:00 am',
    '11:00 am',
    '12:00 pm',
    '01:00 pm',
    '02:00 pm',
    '03:00 pm',
    '04:00 pm',
    '05:00 pm',
    '06:00 pm',
    '07:00 pm',
    '08:00 pm',
    '09:00 pm',
    '10:00 pm',
    '11:00 pm',
  ];
  final List<String> _days = [
    '1 día',
    '2 días',
    '3 días',
    '4 días',
    '5 días',
    '6 días',
    '7 días',
    '8 días',
    '9 días',
    '10 días'
  ];
  final List<String> _intervals = [
    '4 horas',
    '8 horas',
    '12 horas',
    '24 horas'
  ];
  final List<String> _durations = ['Días', 'Siempre'];

  onClickSave() async {
    bool result = false;

    //var
    FREQ_TYPE sendFreq_type;
    int sendTemp;
    int sendStart_hour;
    int? sendDays;
    DURATION sendDuration;
    //freq_type
    if(_selectedOption == "Dosis Diaria"){
      sendFreq_type = FREQ_TYPE.DAILY;
    }else{
      sendFreq_type = FREQ_TYPE.HOUR;
    }
    //freq
    if(sendFreq_type == FREQ_TYPE.DAILY) {
      if(_selectedTimes != null){
        sendTemp = int.parse(_selectedTimes.toString()[0]);
      } else{
        sendTemp = 1;
      }
    }
    else {
      if (_selectedInterval != null) {
        sendTemp = int.parse(_selectedInterval.toString().split(" ")[0]);
      } else {
        sendTemp = 1;
      }
    }
    //start_hour
    if(_selectedHour!=null){
      sendStart_hour = _hours.indexOf(_selectedHour!);
    }else{
      sendStart_hour = 1;
    }
    //days
    if(_selectedDays!=null){
      sendDays = int.parse(_selectedDays.toString().replaceAll(RegExp('[A-Za-zí]'), ''));
    }
    //duration
    if(_selectedDuration == "Días"){
      sendDuration = DURATION.DAILY;
    }else{
      sendDuration = DURATION.FOREVER;
    }

    if(drug == null){
      result = await viewModel.createDrug(
          name: _nameController.text,
          freq_type: sendFreq_type,
          freq: sendTemp,
          start_hour: sendStart_hour,
          days: sendDays,
          duration: sendDuration,
          indications: _indicationsController.text);
    }else{
      result = await viewModel.updateDrug(drug,
          name: _nameController.text,
          freq_type: sendFreq_type,
          freq: sendTemp,
          start_hour: sendStart_hour,
          days: sendDays,
          duration: sendDuration,
          indications: _indicationsController.text);
    }

    if(result){
      Navigator.of(context).pop(true);
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

  }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
      ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>?; //the error is here

    if(args != null && args["drug"] != null){
      setState(() {
        drug = args["drug"];
        if(_selectedOption == null){
          if(drug.freq_type == FREQ_TYPE.DAILY){
            _selectedOption = _options[0];
          }else{
            _selectedOption = _options[1];
          }
        }
        //freq

        if(_selectedTimes == null && _selectedInterval == null) {
          if(drug.freq_type == FREQ_TYPE.DAILY) {
            _selectedTimes = _timesForDay[drug.freq - 1];
          }
          else {
            int idx = _intervals.map((e) => e.split(" ")[0]).toList().indexOf(drug.freq.toString());
            _selectedInterval = _intervals[idx];
          }
        }

        //start_hour
        if(_selectedHour == null){
          _selectedHour = _hours[drug.start_hour];
        }
        //name
        _nameController.text = drug.name;

        //days
        if(_selectedDays == null){
          if(drug.days == null){
            _selectedDays = _days[0];
          }else{
            _selectedDays = _days[drug.days - 1];
          }
        }
        //duration
        if(_selectedDuration == null){
          if(drug.duration == DURATION.DAILY){
            _selectedDuration = _durations[0];
          }else{
            _selectedDuration = _durations[1];
          }
        }
        //indications
        _indicationsController.text = drug.indications;

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
                      height: 0.02.sh,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                          child: Text("Nombre del medicamento",
                              style: AppTextTheme.medium()),
                        )
                      ],
                    ),
                    SizedBox(height: 0.01.sh),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                      child: TextField(
                        controller: _nameController,
                        decoration:
                            Styles.input(context, controller: _nameController),
                      ),
                    ),
                    //SELECT FREQUENCY
                    SizedBox(height: 0.02.sh),
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
                          margin: EdgeInsets.all(13),
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
                                  hint:
                                      Text('  Selecciona una opción...       '),
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
                                    setState(() {
                                      _selectedHour = newValue!;
                                    });
                                  },
                                  items: _hours.map<DropdownMenuItem<String>>(
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
                          )
                        : Container(),

                    //SELECT FOR DURATION
                    SizedBox(
                      height: 0.025.sh,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                          child: Text("Duración", style: AppTextTheme.medium()),
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
                                  hint:
                                      Text('  Selecciona una opción...       '),
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
                                  items: _days.map<DropdownMenuItem<String>>(
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

                    //INPUT FOR INDICATIONS
                    SizedBox(
                      height: 0.025.sh,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                          child: Text("Indicaciones",
                              style: AppTextTheme.medium()),
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
                            maxLines: 3,
                            controller: _indicationsController,
                            decoration:
                            Styles.input(context, controller: _indicationsController),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.02.sh),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0.03.sh),
                      child: ElevatedButton(
                          style: Styles.button(context,
                              color: AppColors.secondary()),
                          onPressed: onClickSave,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0, 0.01.sh, 0, 0.01.sh),
                                child: Text("Guardar",
                                    style: AppTextTheme.medium(
                                        color: Colors.white)),
                              )
                            ],
                          )),
                    ),
                    SizedBox(height: 0.01.sh),
                  ],
                ),
              ),
            ),
            SizedBox(height: 0.04.sh),
            Padding(
              padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0.04.sh),
              child: ElevatedButton(
                  onPressed: onClickReturn,
                  style: Styles.button(context, color: AppColors.primary()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white, size: 40.sp),
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
