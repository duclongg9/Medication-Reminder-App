class MedicineDraft {
  MedicineDraft({required this.name, required this.times, this.imageUrl, this.doseText = ''});

  String name;
  List<String> times;
  String? imageUrl;
  String doseText;

  bool get isCompleted => name.trim().isNotEmpty && times.isNotEmpty && doseText.trim().isNotEmpty;
}
