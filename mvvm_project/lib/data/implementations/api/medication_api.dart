import 'package:mvvm_project/data/dtos/medication/medication_bootstrap_dto.dart';
import 'package:mvvm_project/data/interfaces/api/imedication_api.dart';

class MedicationApi implements IMedicationApi {
  @override
  Future<MedicationBootstrapDto> getBootstrapData() async {
    await Future.delayed(const Duration(milliseconds: 250));

    return const MedicationBootstrapDto(
      suggestions: [
        'Acenocoumarol',
        'Acetazolamid',
        'Aciclovir',
        'Acid valproic (natri)',
        'Aspirin',
        'Paracetamol',
        'Amoxicillin',
      ],
      sampleImages: [
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400',
        'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400',
        'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=400',
      ],
    );
  }
}
