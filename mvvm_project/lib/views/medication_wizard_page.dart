import 'package:flutter/material.dart';
import 'package:mvvm_project/viewmodels/medication/medication_viewmodel.dart';
import 'package:provider/provider.dart';

class MedicationWizardPage extends StatefulWidget {
  const MedicationWizardPage({super.key});

  @override
  State<MedicationWizardPage> createState() => _MedicationWizardPageState();
}

class _MedicationWizardPageState extends State<MedicationWizardPage> {
  final _planNameCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  final _doseCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MedicationViewModel>().loadBootstrapData();
    });
  }

  @override
  void dispose() {
    _planNameCtrl.dispose();
    _searchCtrl.dispose();
    _doseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MedicationViewModel>();
    _syncControllers(vm);

    final title = vm.step == 1 && vm.planName.trim().isNotEmpty
        ? 'Tạo lịch trình uống thuốc cho: ${vm.planName.trim()}'
        : 'Tạo lịch trình uống thuốc';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (vm.step > 0) {
              context.read<MedicationViewModel>().previousStep();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${vm.step + 1} / 3', style: const TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, height: 1.05),
              ),
              const SizedBox(height: 14),
              if (vm.loading) const LinearProgressIndicator(),
              if (vm.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(vm.error!, style: const TextStyle(color: Colors.red)),
                ),
              Expanded(
                child: IndexedStack(
                  index: vm.step,
                  children: [_buildStep1(context, vm), _buildStep2(context, vm), _buildStep3(vm)],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.canContinue
                      ? () {
                          if (vm.step < 2) {
                            context.read<MedicationViewModel>().nextStep();
                          } else {
                            final count = vm.medicines.length;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tạo lịch trình thuốc thành công với $count loại thuốc'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      : null,
                  child: Text(vm.step == 2 ? 'Xong' : 'Tiếp tục'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1(BuildContext context, MedicationViewModel vm) {
    return ListView(
      children: [
        TextField(
          controller: _planNameCtrl,
          decoration: const InputDecoration(labelText: 'Nhập tên liệu trình'),
          onChanged: (value) => context.read<MedicationViewModel>().updatePlanName(value),
        ),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(vm.startDate == null ? 'Chọn ngày bắt đầu' : 'Bắt đầu: ${_dateText(vm.startDate!)}'),
          trailing: const Icon(Icons.calendar_today_outlined),
          onTap: () => _pickDate(context, isStart: true),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(vm.endDate == null ? 'Chọn ngày kết thúc' : 'Kết thúc: ${_dateText(vm.endDate!)}'),
          trailing: const Icon(Icons.calendar_today_outlined),
          onTap: () => _pickDate(context, isStart: false),
        ),
        if (vm.dateValidationMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(vm.dateValidationMessage!, style: const TextStyle(color: Colors.red)),
          ),
        const SizedBox(height: 8),
        const Text(
          'Lựa chọn ngày bắt đầu - kết thúc và đặt tên cho liệu trình của bạn.',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildStep2(BuildContext context, MedicationViewModel vm) {
    final canPickImage = vm.activeMedicine.name.trim().isNotEmpty;
    final canConfigureTime = vm.activeMedicine.imageUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 90,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: vm.medicines.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final medicine = vm.medicines[index];
              final selected = index == vm.selectedMedicine;
              return GestureDetector(
                onLongPress: () => context.read<MedicationViewModel>().toggleDeleteMode(),
                onTap: () => context.read<MedicationViewModel>().selectMedicine(index),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? Colors.black : Colors.transparent,
                          width: selected ? 3 : 0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: selected ? 32 : 28,
                        backgroundColor: selected ? Colors.teal.shade100 : Colors.grey.shade200,
                        backgroundImage: medicine.imageUrl != null ? NetworkImage(medicine.imageUrl!) : null,
                        child: medicine.imageUrl == null
                            ? Text(medicine.name.isEmpty ? '+' : medicine.name[0], style: const TextStyle(fontSize: 22))
                            : null,
                      ),
                    ),
                    if (vm.deleteMode)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: GestureDetector(
                          onTap: () => _confirmDeleteMedicine(context, index),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.remove, color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    if (medicine.isCompleted)
                      const Positioned(
                        right: -2,
                        bottom: -2,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.check, color: Colors.white, size: 12),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(hintText: 'Tìm kiếm tên thuốc'),
                  onChanged: (value) => context.read<MedicationViewModel>().updateSearchKeyword(value),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 52,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: vm.filteredSuggestions.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, index) {
                      final item = vm.filteredSuggestions[index];
                      return ActionChip(
                        label: Text(item),
                        onPressed: () => context.read<MedicationViewModel>().selectSuggestion(item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  vm.activeMedicine.name.isEmpty ? 'Tên thuốc' : vm.activeMedicine.name,
                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: canPickImage ? () => _pickImage(context) : null,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text(vm.activeMedicine.imageUrl == null ? 'Chọn ảnh' : 'Thay ảnh (sửa)'),
                ),
                if (!canPickImage)
                  const Text('Vui lòng chọn tên thuốc trước khi chọn ảnh.', style: TextStyle(color: Colors.black54)),
                if (vm.activeMedicine.imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(vm.activeMedicine.imageUrl!, width: 140, height: 90, fit: BoxFit.cover),
                    ),
                  ),
                const SizedBox(height: 6),
                if (!canConfigureTime)
                  const Text('Hãy chọn ảnh trước, sau đó thêm thời gian uống.', style: TextStyle(color: Colors.black54)),
                Wrap(
                  spacing: 8,
                  children: List.generate(vm.activeMedicine.times.length, (index) {
                    final time = vm.activeMedicine.times[index];
                    return ChoiceChip(
                      label: Text(time),
                      selected: vm.selectedTime == index,
                      onSelected: canConfigureTime ? (_) => context.read<MedicationViewModel>().selectTime(index) : null,
                    );
                  }),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: canConfigureTime ? () => _addTime(context) : null,
                      icon: const Icon(Icons.add_box_outlined),
                    ),
                    if (vm.selectedTime != null)
                      IconButton(
                        onPressed: canConfigureTime ? () => context.read<MedicationViewModel>().removeSelectedTime() : null,
                        icon: const Icon(Icons.delete, color: Colors.black),
                      ),
                  ],
                ),
                if (vm.selectedTime != null)
                  TextField(
                    controller: _doseCtrl,
                    decoration: const InputDecoration(hintText: 'Nhập liều lượng cho khung giờ đã chọn'),
                    onChanged: (value) => context.read<MedicationViewModel>().updateDoseForSelectedTime(value),
                  )
                else
                  const Text('Chạm vào một khung giờ để nhập liều lượng riêng.', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => context.read<MedicationViewModel>().createMedicine(),
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm thuốc mới'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3(MedicationViewModel vm) {
    return ListView.separated(
      itemCount: vm.medicines.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        final medicine = vm.medicines[index];
        return Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(16)),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundImage: medicine.imageUrl != null ? NetworkImage(medicine.imageUrl!) : null,
                child: medicine.imageUrl == null ? Text(medicine.name.isEmpty ? '?' : medicine.name[0]) : null,
              ),
              title: Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              children: [
                ...medicine.times.map(
                  (time) => ListTile(
                    title: Text(medicine.doseFor(time)),
                    trailing: Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDate(BuildContext context, {required bool isStart}) async {
    final now = DateTime.now();
    final vm = context.read<MedicationViewModel>();
    final initialDate = isStart ? (vm.startDate ?? now) : (vm.endDate ?? vm.startDate ?? now);

    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
      initialDate: DateTime(initialDate.year, initialDate.month, initialDate.day),
    );
    if (date == null || !context.mounted) return;
    context.read<MedicationViewModel>().setDate(isStart: isStart, value: date);
  }

  Future<void> _addTime(BuildContext context) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked == null || !context.mounted) return;
    final value = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    context.read<MedicationViewModel>().addTime(value);
  }

  Future<void> _pickImage(BuildContext context) async {
    final image = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: context.read<MedicationViewModel>().sampleImages
            .map(
              (url) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(url, width: 42, height: 42, fit: BoxFit.cover),
                ),
                title: const Text('Dùng ảnh này'),
                onTap: () => Navigator.pop(context, url),
              ),
            )
            .toList(),
      ),
    );
    if (image == null || !context.mounted) return;
    context.read<MedicationViewModel>().updateImage(image);
  }

  Future<void> _confirmDeleteMedicine(BuildContext context, int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa thuốc'),
        content: const Text('Bạn có chắc muốn xóa thuốc này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );
    if (shouldDelete == true && context.mounted) {
      context.read<MedicationViewModel>().deleteMedicine(index);
    }
  }

  void _syncControllers(MedicationViewModel vm) {
    if (_planNameCtrl.text != vm.planName) {
      _planNameCtrl.text = vm.planName;
      _planNameCtrl.selection = TextSelection.collapsed(offset: _planNameCtrl.text.length);
    }
    if (_searchCtrl.text != vm.searchKeyword) {
      _searchCtrl.text = vm.searchKeyword;
      _searchCtrl.selection = TextSelection.collapsed(offset: _searchCtrl.text.length);
    }
    final dose = vm.selectedDoseText();
    if (_doseCtrl.text != dose) {
      _doseCtrl.text = dose;
      _doseCtrl.selection = TextSelection.collapsed(offset: _doseCtrl.text.length);
    }
  }

  String _dateText(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
