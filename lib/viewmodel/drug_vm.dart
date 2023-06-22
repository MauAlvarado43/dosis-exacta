import 'package:dosis_exacta/model/drug.dart';
import 'package:dosis_exacta/utils/constants.dart';
import 'package:dosis_exacta/viewmodel/remainder_vm.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:dosis_exacta/utils/http_handler.dart';

class DrugVM {

  Future<bool> createDrugs(List<Drug> drugs) async {

    try {

      for(int i = 0; i < drugs.length; i++) {
        await drugs[i].save();
        await RemainderVM.makeNextRemainder(drugs[i], cancel: true);
      }

      return true;

    }catch(e){
      return false;
    }

  }

  Future<List<Drug>?> uploadPhoto(XFile image) async {

    try {
      Uint8List bytes = await image.readAsBytes();
      String base64String = base64Encode(bytes);
      var response = await HttpHandler().POST(API_URL + "/analyze_photo", {
        "image": base64String
      });

      if (response.data != null) {

        if (response.data["medicines"] != null) {
          List<Drug> drugs = List<Drug>.from(
              response.data["medicines"].map((medicine) {
                var type = null;
                var duration = null;
                var days = 0;

                if (medicine["frequency_hour"]["unit"] == "hora" ||
                    medicine["frequency_hour"]["unit"] == "horas" ||
                    medicine["frequency_hour"]["unit"] == "hour" ||
                    medicine["frequency_hour"]["unit"] == "hours") {
                  type = FREQ_TYPE.HOUR;
                }
                else {
                  type = FREQ_TYPE.DAILY;
                }

                if (medicine["duration_days"]["unit"] == "dias" ||
                    medicine["duration_days"]["unit"] == "days" ||
                    medicine["duration_days"]["unit"] == "días") {
                  duration = DURATION.DAILY;
                  days = medicine["duration_days"]["value"];
                }
                else {
                  duration = DURATION.FOREVER;
                }

                Drug drug = Drug(
                    name: medicine["medicine"],
                    freq_type: type,
                    freq: medicine["frequency_hour"]["value"],
                    start_hour: 8,
                    duration: duration
                );

                drug.indications = medicine["indications"];
                drug.days = days;

                return drug;
              }));

          return drugs;
        }

        return [];
      }

      return null;
    }
    catch(e) {
      return null;
    }

  }

  Future<List<Drug>?> getDrugs() async {
    return await Drug.getAll();
  }

  Future<bool> createDrug({required String name, required FREQ_TYPE freq_type, required int freq, required int start_hour,int? days ,required DURATION duration,String? indications}) async {

    Drug drug = Drug(name: name, freq_type: freq_type, freq: freq, start_hour: start_hour, duration: duration);
    drug.days = days;
    drug.indications = indications;

    try {
      await drug.save();
      await RemainderVM.makeNextRemainder(drug, cancel: true);
      return true;
    }catch(e){
      return false;
    }

  }

  Future<bool> updateDrug(Drug drug,{name, freq_type, int? freq, int? start_hour, days, duration, indications}) async {

    if(name != null) drug.name = name;
    if(freq_type != null) drug.freq_type = freq_type;
    if(freq != null) drug.freq = freq;
    if(start_hour != null) drug.start_hour = start_hour;
    if(days != null) drug.days = days;
    if(duration != null) drug.duration = duration;
    if(indications != null) drug.indications = indications;

    try {

      await drug.update();
      await RemainderVM.makeNextRemainder(drug, cancel: true);

      return true;
    }catch(e, stacktrace){
      print(e);
      print(stacktrace);
      return false;
    }

  }

  Future<bool> deleteDrug(Drug drug) async {

    try {


      await drug.delete();

      return true;
    }catch(e){
      return false;
    }

  }

}
