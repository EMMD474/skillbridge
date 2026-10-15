import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_constants.dart';
import '../../core/app_routes.dart';
import '../../core/validators.dart';
import '../../models/worker_profile.dart';
import '../../state/auth_scope.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

const List<String> _suggestedSkills = <String>[
  'MIG Welding',
  'Arc Welding',
  'Metal Fabrication',
  'Pattern Making',
  'Measurement',
  'Finishing',
  'Customer Service',
  'Safety Compliance',
  'Site Work',
  'Power Tools',
];

/// Screen - initial worker profile setup after registration.
class WorkerProfileSetupScreen extends StatefulWidget {
  const WorkerProfileSetupScreen({super.key});

  @override
  State<WorkerProfileSetupScreen> createState() =>
      _WorkerProfileSetupScreenState();
}

class _WorkerProfileSetupScreenState extends State<WorkerProfileSetupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _experience = TextEditingController();
  final TextEditingController _rate = TextEditingController();
  final TextEditingController _customSkill = TextEditingController();

  String? _trade;
  final Set<String> _skills = <String>{};

  @override
  void dispose() {
    _bio.dispose();
    _location.dispose();
    _experience.dispose();
    _rate.dispose();
    _customSkill.dispose();
    super.dispose();
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_skills.contains(skill)) {
        _skills.remove(skill);
      } else {
        _skills.add(skill);
      }
    });
  }

  void _addCustomSkill() {
    final String value = _customSkill.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _skills.add(value);
      _customSkill.clear();
    });
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_trade == null) {
      _showMessage('Please select your trade.');
      return;
    }
    if (_skills.isEmpty) {
      _showMessage('Add at least one skill.');
      return;
    }

    AuthScope.read(context).saveWorkerProfile(
      WorkerProfile(
        trade: _trade,
        bio: _bio.text.trim(),
        location: _location.text.trim(),
        yearsExperience: int.tryParse(_experience.text.trim()) ?? 0,
        hourlyRate: double.tryParse(_rate.text.trim()),
        skills: _skills.toList(),
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.workerDashboard,
      (route) => false,
    );
  }

  void _skip() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.workerDashboard,
      (route) => false,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set up your profile'),
        actions: [
          TextButton(onPressed: _skip, child: const Text('Skip')),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            children: [
              Text(
                'Tell clients what you do',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'A complete profile helps you get discovered and win more jobs. '
                'You can edit this later.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Text('Trade', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _trade,
                isExpanded: true,
                decoration: const InputDecoration(
                  hintText: 'Select your trade',
                  prefixIcon: Icon(Icons.handyman_outlined),
                ),
                items: AppConstants.trades
                    .map(
                      (trade) => DropdownMenuItem<String>(
                        value: trade,
                        child: Text(trade),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _trade = value),
              ),
              const SizedBox(height: 20),
              AppTextField(
                label: 'Location',
                hint: 'e.g. Lusaka',
                controller: _location,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.location_on_outlined,
                validator: (value) =>
                    Validators.required(value, field: 'Location'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'About you',
                hint: 'Describe your experience and what you offer',
                controller: _bio,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                validator: (value) => Validators.required(value, field: 'Bio'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Years of experience',
                      hint: '0',
                      controller: _experience,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.timelapse_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: 'Rate / hour (K)',
                      hint: '0',
                      controller: _rate,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.payments_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text('Skills',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  Text(
                    '${_skills.length} selected',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to select the skills you want to be known for.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  ..._suggestedSkills.map(_skillChip),
                  ..._skills
                      .where((s) => !_suggestedSkills.contains(s))
                      .map(_skillChip),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Add a custom skill',
                      hint: 'e.g. Aluminium welding',
                      controller: _customSkill,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 54,
                    child: OutlinedButton(
                      onPressed: _customSkill.text.trim().isEmpty
                          ? null
                          : _addCustomSkill,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(64, 54),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Icon(Icons.add_rounded),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Save and continue',
                icon: Icons.check_rounded,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _skillChip(String skill) {
    final bool selected = _skills.contains(skill);
    return FilterChip(
      label: Text(skill),
      selected: selected,
      onSelected: (_) => _toggleSkill(skill),
      showCheckmark: false,
      avatar: selected
          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
          : null,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
