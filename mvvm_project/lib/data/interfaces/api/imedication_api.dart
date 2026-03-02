import 'package:mvvm_project/data/dtos/medication/medication_bootstrap_dto.dart';

abstract class IMedicationApi {
  Future<MedicationBootstrapDto> getBootstrapData();
}
