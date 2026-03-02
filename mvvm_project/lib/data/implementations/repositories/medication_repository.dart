import 'package:mvvm_project/data/dtos/medication/medication_bootstrap_dto.dart';
import 'package:mvvm_project/data/interfaces/api/imedication_api.dart';
import 'package:mvvm_project/data/interfaces/mapper/imapper.dart';
import 'package:mvvm_project/data/interfaces/repositories/imedication_repository.dart';
import 'package:mvvm_project/domain/entities/medication/medication_bootstrap.dart';

class MedicationRepository implements IMedicationRepository {
  final IMedicationApi api;
  final IMapper<MedicationBootstrapDto, MedicationBootstrap> mapper;

  MedicationRepository({required this.api, required this.mapper});

  @override
  Future<MedicationBootstrap> getBootstrapData() async {
    final dto = await api.getBootstrapData();
    return mapper.map(dto);
  }
}
