import 'package:flutter/foundation.dart';
import 'package:mvvm_project/data/interfaces/repositories/imedication_repository.dart';
import 'package:mvvm_project/domain/entities/medication/medicine_draft.dart';

class MedicationViewModel extends ChangeNotifier {
  final IMedicationRepository repo;

  MedicationViewModel(this.repo);

  bool loading = false;
  String? error;

  int step = 0;
  String planName = '';
  DateTime? startDate;
  DateTime? endDate;

  List<String> suggestions = [];
  List<String> sampleImages = [];

  String searchKeyword = 'Acenocoumarol';
  final List<MedicineDraft> medicines = [MedicineDraft(name: 'Acenocoumarol', times: ['08:00'])];

  int selectedMedicine = 0;
  int? selectedTime;
  bool deleteMode = false;

  MedicineDraft get activeMedicine => medicines[selectedMedicine];

  List<String> get filteredSuggestions => suggestions
      .where((name) => name.toLowerCase().contains(searchKeyword.trim().toLowerCase()))
      .toList();

  bool get canContinueStep1 => planName.trim().isNotEmpty && startDate != null && endDate != null;

  bool get canContinueStep2 => medicines.isNotEmpty && medicines.every((m) => m.isCompleted);

  bool get canContinue => step == 0 ? canContinueStep1 : step == 1 ? canContinueStep2 : true;

  Future<void> loadBootstrapData() async {
    if (loading) return;

    loading = true;
    error = null;
    notifyListeners();

    try {
      final bootstrap = await repo.getBootstrapData();
      suggestions = bootstrap.suggestions;
      sampleImages = bootstrap.sampleImages;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void updatePlanName(String value) {
    planName = value;
    notifyListeners();
  }

  void updateSearchKeyword(String value) {
    searchKeyword = value;
    activeMedicine.name = value;
    notifyListeners();
  }

  void selectSuggestion(String value) {
    searchKeyword = value;
    activeMedicine.name = value;
    notifyListeners();
  }

  void updateDoseText(String value) {
    activeMedicine.doseText = value;
    notifyListeners();
  }

  void setDate({required bool isStart, required DateTime value}) {
    if (isStart) {
      startDate = value;
    } else {
      endDate = value;
    }
    notifyListeners();
  }

  void previousStep() {
    if (step > 0) {
      step -= 1;
      notifyListeners();
    }
  }

  void nextStep() {
    if (!canContinue) return;
    if (step < 2) {
      step += 1;
      notifyListeners();
    }
  }

  void selectMedicine(int index) {
    selectedMedicine = index;
    selectedTime = null;
    deleteMode = false;
    searchKeyword = activeMedicine.name;
    notifyListeners();
  }

  void toggleDeleteMode() {
    deleteMode = !deleteMode;
    notifyListeners();
  }

  void deleteMedicine(int index) {
    if (medicines.length == 1) return;
    medicines.removeAt(index);
    selectedMedicine = selectedMedicine.clamp(0, medicines.length - 1);
    selectedTime = null;
    deleteMode = false;
    searchKeyword = activeMedicine.name;
    notifyListeners();
  }

  void createMedicine() {
    medicines.add(MedicineDraft(name: '', times: ['08:00']));
    selectedMedicine = medicines.length - 1;
    selectedTime = null;
    deleteMode = false;
    searchKeyword = '';
    notifyListeners();
  }

  void selectTime(int index) {
    selectedTime = index;
    notifyListeners();
  }

  void addTime(String value) {
    if (activeMedicine.times.contains(value)) return;
    activeMedicine.times.add(value);
    selectedTime = activeMedicine.times.length - 1;
    notifyListeners();
  }

  void removeSelectedTime() {
    if (selectedTime == null || activeMedicine.times.length <= 1) return;
    activeMedicine.times.removeAt(selectedTime!);
    selectedTime = null;
    notifyListeners();
  }

  void updateImage(String imageUrl) {
    activeMedicine.imageUrl = imageUrl;
    notifyListeners();
  }
}
