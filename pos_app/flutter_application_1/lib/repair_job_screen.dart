import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';

class AddRepairJobScreen extends StatefulWidget {
  const AddRepairJobScreen({super.key});

  @override
  State<AddRepairJobScreen> createState() => _AddRepairJobScreenState();
}

class _AddRepairJobScreenState extends State<AddRepairJobScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _deviceController = TextEditingController();
  final TextEditingController _partsController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _serviceChargeController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedStatus = "Pending";

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  // Database
  Future<void> _saveRepairJob() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('repair_jobs').insert({
          'customer_name': _nameController.text,
          'mobile': _mobileController.text,
          'device_name': _deviceController.text,
          'parts': _partsController.text,
          'estimated_amount': double.tryParse(_amountController.text) ?? 0.0,
          'main_issue': _issueController.text,
          'status': _selectedStatus,
          'service_charge':
              double.tryParse(_serviceChargeController.text) ?? 0.0,
          'description': _descriptionController.text,
          'created_at': DateTime.now().toIso8601String(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("දත්ත සාර්ථකව සුරැකුණි!")),
          );
          _clearFields();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("දෝෂයක්: ${e.toString()}")));
        }
      }
    }
  }

  void _clearFields() {
    _nameController.clear();
    _mobileController.clear();
    _deviceController.clear();
    _partsController.clear();
    _amountController.clear();
    _issueController.clear();
    _serviceChargeController.clear();
    _descriptionController.clear();
    setState(() => _selectedStatus = "Pending");
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [
                      Color(0xFF0F0C29),
                      Color(0xFF302B63),
                      Color(0xFF24243E),
                    ],
                    transform: GradientRotation(
                      _bgController.value * 2 * math.pi,
                    ),
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 25),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  "Customer Name*",
                                  Icons.person,
                                  _nameController,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildTextField(
                                  "Mobile*",
                                  Icons.phone_android,
                                  _mobileController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  "Device Name*",
                                  Icons.devices,
                                  _deviceController,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildTextField(
                                  "Required Parts",
                                  Icons.settings_input_component,
                                  _partsController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  "Estimated Amount*",
                                  Icons.payments,
                                  _amountController,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildTextField(
                                  "Main Issue*",
                                  Icons.report_problem,
                                  _issueController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              Expanded(child: _buildDropdown("Job Status")),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _buildTextField(
                                  "Service Charge*",
                                  Icons.build,
                                  _serviceChargeController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            "Additional Description",
                            Icons.description,
                            _descriptionController,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 40),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add New Repair Job",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Manage your workflow efficiently",
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
        ],
      ),
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );

  Widget _buildTextField(
    String label,
    IconData icon,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF8E2DE2), size: 20),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (v) => v!.isEmpty ? "Required" : null,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFF1A1A2E),
              value: _selectedStatus,
              items: ["Pending", "Repairing", "Completed", "Delivered"]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: _clearFields,
          child: const Text("Clear", style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 20),
        ElevatedButton.icon(
          onPressed: _saveRepairJob,
          icon: const Icon(Icons.add_task),
          label: const Text("Create Repair Job"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8E2DE2),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
