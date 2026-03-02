import 'package:mvvm_project/domain/entities/medication/medication_bootstrap.dart';

abstract class IMedicationRepository {
  Future<MedicationBootstrap> getBootstrapData();
}
