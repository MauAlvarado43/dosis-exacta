import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:dosis_exacta/model/drug.dart';
import 'package:dosis_exacta/viewmodel/drug_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/constants.dart';
import '../common/theme.dart';
import 'dart:io';

class RemainderPhotoResults extends StatefulWidget {

  final XFile image;
  const RemainderPhotoResults({Key? key, required this.image}) : super(key: key);

  @override
  State<RemainderPhotoResults> createState() => StateRemainderPhotoResults();

}

class StateRemainderPhotoResults extends State<RemainderPhotoResults> {

  bool isLoading = true;
  DrugVM viewModel = DrugVM();
  var drugs = null;

  var timeOrPill = [];
  var timeLeft = [];

  onSave() async {

    bool result = await viewModel.createDrugs(drugs);

    if(result) {
      Navigator.of(context).pop();
    }

  }

  returnMenu() {
    Navigator.of(context).pop();
  }

  onEdit(int index) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RecordatorioForm(),
        settings: RouteSettings(
          arguments: {
            "drug": drugs[index]
          }
        ),
      ),
    );

    try {
      if(result != null) {
        if(result["drug"] != null) {
          setState(() {
            drugs[index] = result["drug"];
          });
        }
      }
    }
    catch (e) {}

  }

  onRemove(int index) {
    drugs.removeAt(index);
  }

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {

          drugs = await viewModel.uploadPhoto(widget.image);

          for(int i = 0; i < drugs.length ; i++) {
            if (drugs[i].freq_type == FREQ_TYPE.DAILY) {
              timeOrPill.add(drugs[i].freq.toString() + " por día");
            }
            else {
              timeOrPill.add("Cada " + drugs[i].freq.toString() + " horas"); //cambiar a interval
            }

            if(drugs[i].duration == DURATION.DAILY) {
              timeLeft.add("Por " + drugs[i].days.toString() + " días");
            }
            else {
              timeLeft.add("Sin tiempo límite");
            }
          }

          setState(() { isLoading = false; });

        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Scaffold() : Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text(
                "Fotografia",
                style: AppTextTheme.medium(color: Colors.white)
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              SizedBox(height: 0.1.sw),
              Padding(
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                child: Image.file(File(widget.image.path)),
              ),
              SizedBox(height: 0.05.sh),
              SizedBox(
                height: (drugs.length * 200.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
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
                                    child: Text(timeOrPill[index],style:AppTextTheme.small(),maxLines: 3),
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
                                          onPressed: (){onEdit(index);},
                                          style: Styles.button(context, color: Color(0xFF7977AA)),
                                          child: Text("Editar",style:AppTextTheme.medium(color: Colors.white))
                                      ),
                                    ),
                                    SizedBox(
                                      width: 0.3.sw,
                                      child: ElevatedButton(
                                          onPressed: (){onRemove(index);},
                                          style: Styles.button(context, color: Color(0xFFF44336)),
                                          child: Text("Eliminar",style:AppTextTheme.medium(color: Colors.white))
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
              ),
              SizedBox(height: 0.05.sh),
              Padding( // Contenedor con relleno
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0), // Configura el relleno de los extremos laterales
                child: ElevatedButton( // Agrega un boton al interior
                    onPressed: onSave, // Funcion que se ejecuta al presionar el boton
                    style: Styles.button(context, color: AppColors.secondary()), // Color del boton
                    child: Row( // El contenido del boton se llena como fila
                      mainAxisAlignment: MainAxisAlignment.center, // Centrado
                      children: <Widget> [ // Contiene
                        Padding(
                          padding:
                          EdgeInsets.fromLTRB(0, 0.01.sh, 0, 0.01.sh),
                          child: Text("Guardar",
                              style: AppTextTheme.medium(
                                  color: Colors.white)),
                        )
                      ],
                    )
                ),
              ),
              SizedBox(height: 0.05.sh),
              Padding( // Contenedor con relleno
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0), // Configura el relleno de los extremos laterales
                child: ElevatedButton( // Agrega un boton al interior
                    onPressed: returnMenu, // Funcion que se ejecuta al presionar el boton
                    style: Styles.button(context, color: AppColors.primary()), // Estilo del boton
                    child: Row( // El contenido del boton se llena como fila
                      mainAxisAlignment: MainAxisAlignment.center, // Centrado
                      children: <Widget> [ // Contiene
                        Icon(Icons.arrow_back, color: Colors.white, size: 40.sp), // Agrega un icono
                        SizedBox(width: 20.sp), // Espacio en blanco horizontal
                        Text( // Texto
                            "Regresar",
                            style: AppTextTheme.medium(color: Colors.white) // Formato del texto
                        ),
                        SizedBox(width: 25.sp) // Espacio en blanoc
                      ],
                    )
                ),
              ),
              SizedBox(height: 0.1.sw) // Espacio en blanco vertical
            ],
          ),
        )
    );
  }

}

class RecordatorioForm extends StatefulWidget {
  
  const RecordatorioForm({ Key? key }) : super(key: key);

  @override
  State<RecordatorioForm> createState() => _RecordatorioForm();
  
}

class _RecordatorioForm extends State<RecordatorioForm> {
  
  bool isLoading = true;
  
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
    '10 días',
    '11 días',
    '12 días',
    '13 días',
    '14 días',
    '15 días',
    '16 días',
    '17 días',
    '18 días',
    '19 días',
    '20 días',
    '21 días',
    '22 días',
    '23 días',
    '24 días',
    '25 días',
    '26 días',
    '27 días',
    '28 días',
    '29 días',
    '30 días',
    '31 días'
  ];
  
  final List<String> _intervals = [
    '4 horas',
    '8 horas',
    '12 horas',
    '24 horas'
  ];
  
  final List<String> _durations = ['Días', 'Siempre'];

  onClickSave() async {
    
    FREQ_TYPE sendFreq_type;
    int sendTemp;
    int sendStart_hour;
    int? sendDays;
    DURATION sendDuration;

    if(_selectedOption == "Dosis Diaria"){
      sendFreq_type = FREQ_TYPE.DAILY;
    }else{
      sendFreq_type = FREQ_TYPE.HOUR;
    }

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

    if(_selectedHour!=null){
      sendStart_hour = _hours.indexOf(_selectedHour!);
    }else{
      sendStart_hour = 1;
    }

    if(_selectedDays!=null){
      sendDays = int.parse(_selectedDays.toString().replaceAll(RegExp('[A-Za-zí]'), ''));
    }

    if(_selectedDuration == "Días"){
      sendDuration = DURATION.DAILY;
    }else{
      sendDuration = DURATION.FOREVER;
    }

    Drug newDrug = Drug(
      name: _nameController.text,
      freq_type: sendFreq_type,
      freq: sendTemp,
      start_hour: sendStart_hour,
      duration: sendDuration,
    );

    newDrug.days = sendDays;
    newDrug.indications = _indicationsController.text;

    Navigator.of(context).pop({ "drug": newDrug });

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
    
    Map<dynamic, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>?;

    if(args != null && args["drug"] != null) {
      setState(() {
        
        drug = args["drug"];
        
        if(_selectedOption == null){
          if(drug.freq_type == FREQ_TYPE.DAILY){
            _selectedOption = _options[0];
          }else{
            _selectedOption = _options[1];
          }
        }

        if(_selectedTimes == null && _selectedInterval == null) {
          if(drug.freq_type == FREQ_TYPE.DAILY) {
            _selectedTimes = _timesForDay[drug.freq - 1];
          }
          else {
            int idx = _intervals.map((e) => e.split(" ")[0]).toList().indexOf(drug.freq.toString());
            _selectedInterval = _intervals[idx];
          }
        }

        if(_selectedHour == null){
          _selectedHour = _hours[drug.start_hour];
        }
        
        _nameController.text = drug.name;

        if(_selectedDays == null){
          if(drug.days == null){
            _selectedDays = _days[0];
          }else{
            _selectedDays = _days[drug.days - 1];
          }
        }
        
        if(_selectedDuration == null){
          if(drug.duration == DURATION.DAILY){
            _selectedDuration = _durations[0];
          }else{
            _selectedDuration = _durations[1];
          }
        }
        
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
