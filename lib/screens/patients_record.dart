import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/app_colors.dart';
import '../models/patients_record.dart';
import '../services/patients_record.dart';

class PatientsRecord extends StatefulWidget {
  final int nurseId;
  const PatientsRecord({super.key, required this.nurseId});

  @override
  State<PatientsRecord> createState() => _PatientsRecordState();
}

class _PatientsRecordState extends State<PatientsRecord> {
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _notesController = TextEditingController();
  final _otherSymptomController = TextEditingController();

  final List<Map<String, dynamic>> _symptoms = [
    {"name": "Fever", "icon": Icons.thermostat_rounded},
    {"name": "Cough", "icon": Icons.sick_rounded},
    {"name": "Dizziness", "icon": Icons.rotate_right_rounded},
    {"name": "Chest Pain", "icon": Icons.monitor_heart_rounded},
    {"name": "Fatigue", "icon": Icons.battery_full_rounded},
    {"name": "Injury", "icon": Icons.healing_rounded},
    {"name": "Other:", "icon": Icons.edit_note_rounded},
  ];

  final List<String> _selectedSymptoms = [];

  @override
  void dispose() {
    for (final c in [_dateController, _diagnosisController, _treatmentController, _notesController, _otherSymptomController]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryGradient.colors.first,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Combine selected symptoms
    String symptoms = _selectedSymptoms.join(", ");
    if (_selectedSymptoms.contains("Other:") && _otherSymptomController.text.isNotEmpty) {
      symptoms = _selectedSymptoms.where((s) => s != "Other:").join(", ");
      symptoms += (symptoms.isEmpty ? "" : ", ") + _otherSymptomController.text;
    }

    final patientRecord = PatientRecord(
      nursingDiagnosis: "${_diagnosisController.text}${symptoms.isNotEmpty ? " - Symptoms: $symptoms" : ""}",
      nursingIntervention: _treatmentController.text,
      nurseId: widget.nurseId,
    );

    final result = await PatientRecordService.createPatientRecord(patientRecord);

    if (result["success"]) {
      _formKey.currentState?.reset();
      _selectedSymptoms.clear();
      _otherSymptomController.clear();

      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.done_all_rounded, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Record Submitted!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF188114)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
      setState(() {}); // refresh UI for cleared symptoms
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit record: ${result['error']}")),
      );
    }
  }

  Widget _animatedTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool readOnly = false,
    bool requiredField = true,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    final focusNode = FocusNode();
    return StatefulBuilder(builder: (context, setState) {
      focusNode.addListener(() => setState(() {}));
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: focusNode.hasFocus ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(15),
          boxShadow: focusNode.hasFocus
              ? [BoxShadow(color: AppColors.primaryGradient.colors.first.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))]
              : [],
        ),
        padding: const EdgeInsets.all(1.2),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: maxLines,
            validator: (value) => requiredField && (value == null || value.isEmpty) ? "This field is required" : null,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: ShaderMask(shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds), child: Icon(icon, color: Colors.white)),
              labelStyle: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSymptomChip(String symptom, IconData icon, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => isSelected ? _selectedSymptoms.remove(symptom) : _selectedSymptoms.add(symptom)),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : AppColors.primaryGradient.colors.first, size: 20),
            const SizedBox(width: 6),
            Text(symptom, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Symptoms", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _symptoms.map((s) => _buildSymptomChip(s["name"], s["icon"], _selectedSymptoms.contains(s["name"]))).toList(),
        ),
        if (_selectedSymptoms.contains("Other:")) ...[
          const SizedBox(height: 6),
          _animatedTextField(_otherSymptomController, "Please specify...", Icons.edit_note_rounded, requiredField: false, maxLines: 1),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _animatedTextField(_dateController, "Date", Icons.calendar_today_rounded, readOnly: true, onTap: _pickDate),
                const SizedBox(height: 16),
                _animatedTextField(_diagnosisController, "Nursing Diagnosis", Icons.medical_information_rounded),
                const SizedBox(height: 16),
                _animatedTextField(_treatmentController, "Nursing Intervention", Icons.healing_rounded),
                const SizedBox(height: 16),
                _buildSymptomSection(),
                const SizedBox(height: 16),
                _animatedTextField(_notesController, "Notes", Icons.note_rounded, maxLines: 3, requiredField: false),
                const SizedBox(height: 35),
                _SubmitButton(onTap: _submitForm, label: "Submit Record"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  const _SubmitButton({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
        child: Center(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
      ),
    );
  }
}
