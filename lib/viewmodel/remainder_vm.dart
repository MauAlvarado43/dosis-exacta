import 'package:dosis_exacta/model/remainder.dart';
import 'package:dosis_exacta/model/drug.dart';
class RemainderVM {

  Future<List<Remainder>?> getRemainders() async {
    return await Remainder.getAll();
  }

  Future<bool> createRemainder({ required bool ingested, required DateTime date, required Drug drug }) async {

    Remainder remaind = Remainder(ingested: ingested, date: date, drug: drug);

    try {
      await remaind.save();
      return true;
    }
    catch(e){
      return false;
    }

  }

  Future<bool> updateRemainder(Remainder remaind, { ingested, date, drug }) async {

    if(ingested != null) remaind.ingested = ingested;
    if(date != null) remaind.date = date;
    if(drug != null) remaind.drug = drug;

    try {
      await remaind.update();
      return true;
    }
    catch(e){
      return false;
    }

  }

  Future<bool> deleteRemainder(Remainder remaind) async {

    try {
      await remaind.delete();
      return true;
    }
    catch(e){
      return false;
    }

  }

}