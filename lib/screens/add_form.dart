import 'package:flutter/material.dart';
import '../services/add_form.dart';
import '../widgets/app_colors.dart';
import '../models/add_form.dart';

class AddFormScreen extends StatefulWidget {
  const AddFormScreen({super.key});

  @override
  State<AddFormScreen> createState() => _AddFormScreenState();
}

class _AddFormScreenState extends State<AddFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _patientNameController = TextEditingController();
  final _issueTypeController = TextEditingController();
  final _issueDescController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void dispose() {
    _patientNameController.dispose();
    _issueTypeController.dispose();
    _issueDescController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final formData = AddFormModel(
      patientName: _patientNameController.text,
      issueType: _issueTypeController.text,
      issueDescription: _issueDescController.text,
      status: _statusController.text,
    );

    final result = await AddFormService.createAddForm(formData);

    if (result["success"] == true) {
      _patientNameController.clear();
      _issueTypeController.clear();
      _issueDescController.clear();
      _statusController.clear();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Form Submitted!"),
          content: const Text("The form has been successfully submitted."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["error"] ?? "Unknown error")),
      );
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryGradient.colors.first),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Add Form"),
        backgroundColor: AppColors.primaryGradient.colors.first,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                  _patientNameController, "Patient Name", Icons.person),
              const SizedBox(height: 16),

              _buildTextField(
                  _issueTypeController, "Issue Type", Icons.medical_services),
              const SizedBox(height: 16),

              _buildTextField(_issueDescController, "Issue Description",
                  Icons.description,
                  maxLines: 3),
              const SizedBox(height: 16),

              _buildTextField(_statusController, "Status", Icons.info),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGradient.colors.first,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Submit Form",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
