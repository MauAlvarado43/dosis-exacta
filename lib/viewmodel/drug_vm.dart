import 'package:dosis_exacta/model/drug.dart';
import 'package:dosis_exacta/utils/constants.dart';
import 'package:dosis_exacta/viewmodel/remainder_vm.dart';

class DrugVM {

  Future<List<Drug>?> getDrugs() async {
    return await Drug.getAll();
  }

  Future<bool> createDrug({required String name, required FREQ_TYPE freq_type, required int freq, required int start_hour,int? days ,required DURATION duration,String? indications}) async {

    Drug drug = Drug(name: name, freq_type: freq_type, freq: freq, start_hour: start_hour, duration: duration);
    drug.days = days;
    drug.indications = indications;

    try {
      await drug.save();

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
    }catch(e){
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
