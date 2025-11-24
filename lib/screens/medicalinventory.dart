import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';

class MedicalInventory extends StatefulWidget {
  const MedicalInventory({super.key});

  @override
  State<MedicalInventory> createState() => _MedicalInventoryState();
}

class _MedicalInventoryState extends State<MedicalInventory> {
  List<Map<String, String>> medicines = [
    {'name': 'Paracetamol', 'category': 'Pain Reliever', 'quantity': '120', 'expiry': '12/2026'},
    {'name': 'Amoxicillin', 'category': 'Antibiotic', 'quantity': '85', 'expiry': '05/2027'},
    {'name': 'Cetirizine', 'category': 'Antihistamine', 'quantity': '150', 'expiry': '09/2026'},
    {'name': 'Ibuprofen', 'category': 'Anti-inflammatory', 'quantity': '22', 'expiry': '03/2027'},
    {'name': 'Insulin', 'category': 'Hormone', 'quantity': '8', 'expiry': '11/2024'},
  ];

  Color _getQuantityColor(String quantityStr) {
    final quantity = int.tryParse(quantityStr) ?? 0;
    if (quantity < 10) return Colors.red.shade700;
    if (quantity < 50) return Colors.orange.shade700;
    return Colors.green.shade700;
  }

  bool _isExpired(String expiry) {
    if (expiry.length < 7) return false;
    final parts = expiry.split('/');
    if (parts.length != 2) return false;
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || year == null) return false;
    final expiryDate = DateTime(year, month + 1, 0);
    return expiryDate.isBefore(DateTime.now());
  }

  void _showMedicineDialog({Map<String, String>? medicine, int? index}) {
    final nameController = TextEditingController(text: medicine?['name'] ?? '');
    final categoryController = TextEditingController(text: medicine?['category'] ?? '');
    final quantityController = TextEditingController(text: medicine?['quantity'] ?? '');
    final expiryController = TextEditingController(text: medicine?['expiry'] ?? '');
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(3),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        medicine == null ? "Add Medicine" : "Edit Medicine",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInput(nameController, "Medicine Name"),
                      const SizedBox(height: 16),
                      _buildInput(categoryController, "Category"),
                      const SizedBox(height: 16),
                      _buildInput(quantityController, "Quantity", keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      _buildInput(expiryController, "Expiry (MM/YYYY)"),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final newMedicine = {
                                    'name': nameController.text,
                                    'category': categoryController.text,
                                    'quantity': quantityController.text,
                                    'expiry': expiryController.text,
                                  };
                                  setState(() {
                                    if (index != null) {
                                      medicines[index] = newMedicine;
                                    } else {
                                      medicines.add(newMedicine);
                                    }
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGradient.colors.first,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text(
                                "Save",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  Colors.red.shade500,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput(TextEditingController controller, String placeholder,
    {TextInputType keyboardType = TextInputType.text}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(14),
    ),
    padding: const EdgeInsets.all(2),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black87),
      validator: (value) => value == null || value.isEmpty ? "Required" : null,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
  );
}

  Widget _buildMedicineCard(Map<String, String> med, int index) {
    final quantityColor = _getQuantityColor(med['quantity']!);
    final isExpired = _isExpired(med['expiry']!);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => _showMedicineDialog(medicine: med, index: index),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med['name']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Category: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      med['category']!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      "Quantity: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      med['quantity']!,
                      style: TextStyle(
                        color: quantityColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      "Expiry: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${med['expiry']}${isExpired ? ' (Expired)' : ''}",
                      style: TextStyle(
                        color: isExpired ? Colors.red.shade700 : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        overlayColor: Colors.transparent,
                      ),
                      onPressed: () =>
                          _showMedicineDialog(medicine: med, index: index),
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      style: TextButton.styleFrom(
                        overlayColor: Colors.transparent,
                      ),
                      onPressed: () => _deleteMedicine(index),
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: medicines.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_rounded, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text("Your inventory is empty.", style: TextStyle(fontSize: 18, color: Colors.black54)),
                    const Text("Tap the '+' button to add an item.", style: TextStyle(fontSize: 14, color: Colors.black45)),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) => _buildMedicineCard(medicines[index], index),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMedicineDialog(),
        backgroundColor: AppColors.primaryGradient.colors.first,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        label: const Text("Add Medicine", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
