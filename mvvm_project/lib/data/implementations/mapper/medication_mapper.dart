import 'package:mvvm_project/data/dtos/medication/medication_bootstrap_dto.dart';
import 'package:mvvm_project/data/interfaces/mapper/imapper.dart';
import 'package:mvvm_project/domain/entities/medication/medication_bootstrap.dart';

class MedicationBootstrapMapper
    implements IMapper<MedicationBootstrapDto, MedicationBootstrap> {
  @override
  MedicationBootstrap map(MedicationBootstrapDto input) {
    return MedicationBootstrap(
      suggestions: input.suggestions,
      sampleImages: input.sampleImages,
    );
  }
}
