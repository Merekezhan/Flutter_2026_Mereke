import 'package:flutter/material.dart';

import '../models/pastry.dart';
import '../models/pastry_category.dart';
import '../utils/format.dart';

class PastryFormScreen extends StatefulWidget {
  const PastryFormScreen({super.key, this.original});

  final Pastry? original;

  @override
  State<PastryFormScreen> createState() => _PastryFormScreenState();
}

class _PastryFormScreenState extends State<PastryFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _placeController;
  late final TextEditingController _limitController;
  late final TextEditingController _descriptionController;

  late final FocusNode _placeFocus;

  PastryCategory? _category;
  DateTime? _selectedDate;

  bool _isOnline = false;
  bool _isSaving = false;
  bool _allowPop = false;
  bool _isDiscardDialogOpen = false;

  bool get _isDirty {
    final original = widget.original;

    return _titleController.text != (original?.title ?? '') ||
        _placeController.text != (original?.place ?? '') ||
        _limitController.text != (original?.limit.toString() ?? '10') ||
        _descriptionController.text != (original?.description ?? '') ||
        _category != original?.category ||
        _selectedDate != original?.readyAt ||
        _isOnline != (original?.isOnline ?? false);
  }

  @override
  void initState() {
    super.initState();

    final original = widget.original;

    _titleController = TextEditingController(text: original?.title ?? '');

    _placeController = TextEditingController(text: original?.place ?? '');

    _limitController = TextEditingController(
      text: original?.limit.toString() ?? '10',
    );

    _descriptionController = TextEditingController(
      text: original?.description ?? '',
    );

    _placeFocus = FocusNode();

    _category = original?.category;
    _selectedDate = original?.readyAt;
    _isOnline = original?.isOnline ?? false;

    // Rebuild PopScope when text fields change.
    _titleController.addListener(_onFieldChanged);
    _placeController.addListener(_onFieldChanged);
    _limitController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_onFieldChanged);
    _placeController.removeListener(_onFieldChanged);
    _limitController.removeListener(_onFieldChanged);
    _descriptionController.removeListener(_onFieldChanged);

    _titleController.dispose();
    _placeController.dispose();
    _limitController.dispose();
    _descriptionController.dispose();
    _placeFocus.dispose();

    super.dispose();
  }

  Future<void> _pickDateTime() async {
    if (_isSaving) return;

    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(days: 1)),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (!mounted || date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: _selectedDate == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(_selectedDate!),
    );

    if (!mounted || time == null) return;

    setState(() {
      _selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    final category = _category;
    final date = _selectedDate;

    if (category == null || date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a category and date')),
      );
      return;
    }

    if (widget.original == null && !date.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Choose a future date')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Simulate saving data.
    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final original = widget.original;

    final description = _descriptionController.text.trim();

    final pastry = Pastry(
      id: original?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      category: category,
      readyAt: date,
      limit: int.parse(_limitController.text.trim()),
      names: original?.names ?? <String>[],
      isOnline: _isOnline,
      place: _placeController.text.trim(),
      description: description.isEmpty ? null : description,
      isFavourite: original?.isFavourite ?? false,
    );

    // Allow navigation only after a successful save.
    setState(() {
      _isSaving = false;
      _allowPop = true;
    });

    Navigator.pop(context, pastry);
  }

  Future<void> _confirmDiscard() async {
    if (_isDiscardDialogOpen || _isSaving) return;

    _isDiscardDialogOpen = true;

    final discard = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text('Your edits will not be saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Keep editing'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    _isDiscardDialogOpen = false;

    if (discard != true) return;

    setState(() {
      _allowPop = true;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Pastry>(
      canPop: !_isSaving && (_allowPop || !_isDirty),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (!_isSaving) {
          _confirmDiscard();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.original == null ? 'New pastry batch' : 'Edit pastry batch',
          ),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              TextFormField(
                controller: _titleController,
                enabled: !_isSaving,
                maxLength: 60,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Pastry name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';

                  if (text.length < 3 || text.length > 60) {
                    return 'Enter 3–60 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PastryCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final category in PastryCategory.values)
                    DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                ],
                onChanged: _isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _category = value;
                        });
                      },
                validator: (value) {
                  if (value == null) {
                    return 'Choose a category';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isSaving ? null : _pickDateTime,
                icon: const Icon(Icons.calendar_month),
                label: Text(formatDate(_selectedDate)),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Online reservation'),
                subtitle: Text(
                  _isOnline
                      ? 'Customers use a reservation link'
                      : 'Customers collect pastries at an address',
                ),
                value: _isOnline,
                onChanged: _isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _isOnline = value;
                        });
                      },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _placeController,
                focusNode: _placeFocus,
                enabled: !_isSaving,
                textInputAction: TextInputAction.next,
                keyboardType: _isOnline
                    ? TextInputType.url
                    : TextInputType.streetAddress,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  labelText: _isOnline ? 'Reservation link' : 'Pickup address',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';

                  if (text.isEmpty) {
                    return 'This field is required';
                  }

                  if (_isOnline && !text.contains('://')) {
                    return 'Link must include ://';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _limitController,
                enabled: !_isSaving,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Portion limit (1–500)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final count = int.tryParse(value?.trim() ?? '');

                  if (count == null || count < 1 || count > 500) {
                    return 'Enter a number from 1 to 500';
                  }

                  final reserved = widget.original?.taken ?? 0;

                  if (count < reserved) {
                    return 'Cannot be below reserved count';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                enabled: !_isSaving,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save pastry'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
