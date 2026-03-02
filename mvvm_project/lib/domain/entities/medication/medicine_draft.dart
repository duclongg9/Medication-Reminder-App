class MedicineDraft {
  MedicineDraft({required this.name, required this.times, this.imageUrl, Map<String, String>? dosesByTime})
      : dosesByTime = dosesByTime ?? {};

  String name;
  List<String> times;
  String? imageUrl;
  Map<String, String> dosesByTime;

  String doseFor(String time) => dosesByTime[time] ?? '';

  void updateDoseForTime(String time, String dose) {
    dosesByTime[time] = dose;
  }

  bool get isCompleted {
    if (name.trim().isEmpty || imageUrl == null || times.isEmpty) return false;
    return times.every((time) => doseFor(time).trim().isNotEmpty);
  }
}
