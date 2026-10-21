import 'package:flutter/material.dart';

import 'summary_card.dart';

void main() => runApp(const MyApp());

const groups = ['IT-2301', 'IT-2302', 'IT-2303', 'IT-2304', 'IT-2305'];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign Up Form',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();

  String? _group;
  DateTime? _birth;
  bool _agreed = false;
  bool _done = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _birthController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    if (!_agreed) return;

    if (_formKey.currentState!.validate()) {
      setState(() => _done = true);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2005, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;
    if (!mounted) return;

    setState(() {
      _birth = picked;
      _birthController.text =
          '${picked.day.toString().padLeft(2, '0')}.'
          '${picked.month.toString().padLeft(2, '0')}.'
          '${picked.year}';
    });
  }

  void _startOver() {
    setState(() {
      _name.clear();
      _email.clear();
      _password.clear();
      _confirm.clear();
      _birthController.clear();
      _group = null;
      _birth = null;
      _agreed = false;
      _done = false;
    });
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your full name',
            ),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _emailFocus.requestFocus(),
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            validator: (value) {
              final name = (value ?? '').trim();
              if (name.length < 2)
                return 'Name must have at least 2 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _email,
            focusNode: _emailFocus,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'name@kbtu.kz',
            ),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            validator: (value) {
              final email = (value ?? '').trim();
              final at = email.indexOf('@');
              if (at < 1 || !email.substring(at + 1).contains('.')) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _password,
            decoration: const InputDecoration(
              labelText: 'Password',
              helperText: 'At least 8 characters',
            ),
            obscureText: true,
            textInputAction: TextInputAction.next,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            validator: (value) {
              if ((value ?? '').length < 8) {
                return 'Password must have at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirm,
            decoration: const InputDecoration(labelText: 'Confirm password'),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            validator: (value) {
              if (value != _password.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _group,
            decoration: const InputDecoration(labelText: 'Group'),
            items: [
              for (final group in groups)
                DropdownMenuItem(value: group, child: Text(group)),
            ],
            onChanged: (value) => setState(() => _group = value),
            validator: (value) => value == null ? 'Choose a group' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _birthController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date of birth',
              suffixIcon: Icon(Icons.calendar_month),
            ),
            onTap: _pickDate,
            validator: (_) =>
                _birth == null ? 'Choose your date of birth' : null,
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('I agree to the rules'),
            value: _agreed,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              setState(() => _agreed = value ?? false);
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _agreed ? _submit : null,
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: _done
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SummaryCard(
                    name: _name.text.trim(),
                    email: _email.text.trim(),
                    group: _group ?? '',
                    birthDate: _birthController.text,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _startOver,
                    child: const Text('Start over'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _buildForm(),
                ),
              ),
            ),
    );
  }
}
