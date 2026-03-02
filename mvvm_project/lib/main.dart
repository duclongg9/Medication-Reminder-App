import 'package:flutter/material.dart';
import 'package:mvvm_project/di.dart';
import 'package:mvvm_project/viewmodels/medication/medication_viewmodel.dart';
import 'package:mvvm_project/views/medication_wizard_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MedicationViewModel>(
      create: (_) => buildMedicationVM(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MedicationWizardPage(),
      ),
    );
  }
}

