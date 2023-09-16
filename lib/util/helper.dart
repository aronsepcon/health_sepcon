import 'dart:developer';

import 'package:sepcon_salud/resource/model/dosis_model.dart';
import 'package:sepcon_salud/resource/model/refuerzo_model.dart';
import 'package:sepcon_salud/resource/model/vacuna_model.dart';

class Helper{

  static validateDates(List<VacunaModel> vacunasModel){
    for(VacunaModel vacuna in vacunasModel){

      log("vacuna : ${vacuna.nombre} , dosis : ${vacuna.vacunaDetalle!.dosis.length} , refuerzo : ${vacuna.vacunaDetalle!.refuerzos.length}");

      // VACUNAS CON UNA SOLA DOSIS
      if(vacuna.vacunaDetalle!.dosis.length == 1 &&
          vacuna.vacunaDetalle!.refuerzos.isEmpty){

        if(vacuna.vacunaDetalle!.dosis.last.fecha != null){
          vacuna.vigenciaVacuna = VigenciaVacuna.active;
        }else{
          vacuna.vigenciaVacuna = VigenciaVacuna.empty;
        }
      }

      // VACUNAS CON MAS DE UNA DOSIS
      if(vacuna.vacunaDetalle!.dosis.length > 1 &&
          vacuna.vacunaDetalle!.refuerzos.isEmpty){

        int amountNull = 0;

        for(DosisModel dosisModel in vacuna.vacunaDetalle!.dosis){
          if(dosisModel.fecha == null){
            amountNull += 1;
          }
        }

        DosisModel lastDosis = vacuna.vacunaDetalle!.dosis.last;

        if( amountNull == vacuna.vacunaDetalle!.dosis.length ){
          vacuna.vigenciaVacuna = VigenciaVacuna.empty;
        }else{

          if( lastDosis.fecha != null ) {
            if(calculateDay(lastDosis.fecha!) <= 0){
              vacuna.vigenciaVacuna = stateVacuum(lastDosis.fecha!);
              vacuna.amountDay = calculateDay(lastDosis.fecha!);
            }else{
              vacuna.vigenciaVacuna = VigenciaVacuna.active;
            }

          } else {

            List<int> listIndex = [];
            int index = 0;

            for(DosisModel dosisModelTemp in vacuna.vacunaDetalle!.dosis){
              if(dosisModelTemp.fecha != null){
                listIndex.add(index);
              }
              index += 1;
            }

            // Verificar si tiene almenos dos items

            if(listIndex.length > 1){
              int indexSelected = listIndex.last;
              vacuna.vigenciaVacuna = stateVacuum(vacuna.vacunaDetalle!.dosis[indexSelected].fecha!);
              vacuna.amountDay = calculateDay(vacuna.vacunaDetalle!.dosis[indexSelected].fecha!);

            }else if(listIndex.length == 1){
              // ACTIVE
              vacuna.vigenciaVacuna = VigenciaVacuna.active;
            }else if(listIndex.isEmpty){
              // ACTIVE
              vacuna.vigenciaVacuna = VigenciaVacuna.empty;
            }

          }
        }


      }

      // VACUNAS CON MAS DE UNA DOSIS Y MAS DE UN REFUERZO
      if(vacuna.vacunaDetalle!.dosis.length > 1 &&
          vacuna.vacunaDetalle!.refuerzos.length > 1) {

        List<DosisModel> dosisGeneral = [];

        int amountNull = 0;

        for (DosisModel dosisModel in vacuna.vacunaDetalle!.dosis) {
          dosisGeneral.add(dosisModel);
          if(dosisModel.fecha == null){
            amountNull += 1;
          }
        }

        for (RefuerzoModel refuerzoModel in vacuna.vacunaDetalle!.refuerzos) {
          DosisModel dosisModel = DosisModel(
              refuerzoModel.nombre, refuerzoModel.nDosis,
              refuerzoModel.documento, refuerzoModel.estado,
              refuerzoModel.proximaFecha);
          dosisGeneral.add(dosisModel);
          if(dosisModel.fecha == null){
            amountNull += 1;
          }
        }

        // Si la cantidad de null es igual a la cantidad total
        if( amountNull == dosisGeneral.length ){
          vacuna.vigenciaVacuna = VigenciaVacuna.empty;
        }else{

          if(dosisGeneral.last.fecha != null){
            vacuna.vigenciaVacuna = stateVacuum(dosisGeneral.last.fecha!);
            vacuna.amountDay = calculateDay(dosisGeneral.last.fecha!);

          }else{

            List<int> listIndex = [];
            int index = 0;

            for(DosisModel dosisModelTemp in dosisGeneral){
              if(dosisModelTemp.fecha != null){
                listIndex.add(index);
              }
              index += 1;
            }

            // Verificar si tiene almenos dos items

            if(listIndex.length > 1){
              int indexSelected = listIndex.last;

              vacuna.vigenciaVacuna = stateVacuum(dosisGeneral[indexSelected].fecha!);
              vacuna.amountDay = calculateDay(dosisGeneral[indexSelected].fecha!);

            }else if(listIndex.length == 1){
              // ACTIVE
              vacuna.vigenciaVacuna = VigenciaVacuna.active;
            }else if(listIndex.isEmpty){
              // ACTIVE
              vacuna.vigenciaVacuna = VigenciaVacuna.empty;
            }
          }

        }


      }

      // VACUNAS SIN DOSIS Y MAS DE UN REFUERZO
      if(vacuna.vacunaDetalle!.dosis.isEmpty  &&
          vacuna.vacunaDetalle!.refuerzos.length > 1){

        int amountNull = 0;

        for(RefuerzoModel refuerzoModel in vacuna.vacunaDetalle!.refuerzos){
          if(refuerzoModel.proximaFecha == null){
            amountNull += 1;
          }
        }
        if(amountNull != vacuna.vacunaDetalle!.refuerzos.length ){

          RefuerzoModel refuerzoModel = vacuna.vacunaDetalle!.refuerzos[1];

          vacuna.vigenciaVacuna = stateVacuum(refuerzoModel.proximaFecha!);
          vacuna.amountDay = calculateDay(refuerzoModel.proximaFecha!);

        }else if (amountNull == 1){
          vacuna.vigenciaVacuna = VigenciaVacuna.active;

        }else if ( amountNull == 0 ){
          vacuna.vigenciaVacuna = VigenciaVacuna.empty;
        }
      }

    }
  }

  static VigenciaVacuna stateVacuum(String fecha){
    VigenciaVacuna vigenciaVacuna = VigenciaVacuna.empty;
    DateTime now = DateTime.now();
    DateTime parseFecha = DateTime.parse(fecha);

    int amountDay = now.difference(parseFecha).inDays;

    log(" $now - $parseFecha : $amountDay");
    // VIGENTE
    if( amountDay > 0){
      vigenciaVacuna = VigenciaVacuna.noActive;
    }
    // POR VENCERSE
    if( -7 < amountDay && amountDay <= 0 ){
      vigenciaVacuna = VigenciaVacuna.toExpire;
    }
    // VENCIDO
    if( amountDay <= -7 ){
      vigenciaVacuna = VigenciaVacuna.active;
    }
    return vigenciaVacuna;
  }

  static int calculateDay(String fecha){
    DateTime now = DateTime.now();
    DateTime parseFecha = DateTime.parse(fecha);

    int amountDay = now.difference(parseFecha).inDays;
    return amountDay;
  }


  static editValue(List<VacunaModel> listVacunaModel){
    for(VacunaModel vacunaModel in
    listVacunaModel){
      if(vacunaModel.nombre == "HepatitisB"){
        vacunaModel.vacunaDetalle!.dosis[0].fecha = "2023-08-11";
        vacunaModel.vacunaDetalle!.dosis[1].fecha = "2023-09-11";
        vacunaModel.vacunaDetalle!.dosis[2].fecha = null;
      }
      if(vacunaModel.nombre == "Difteria"){
        vacunaModel.vacunaDetalle!.dosis[2].fecha = "2023-08-11";
        vacunaModel.vacunaDetalle!.refuerzos[0].proximaFecha = "2023-09-11";
        vacunaModel.vacunaDetalle!.refuerzos[1].proximaFecha = null;
      }
    }
  }
}