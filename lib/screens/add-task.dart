import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTaskToDatabase extends StatefulWidget {
  final String? taskId;
  final String? initialName;
  final int? initialAge;

  const AddTaskToDatabase({
    super.key,
    this.taskId,
    this.initialName,
    this.initialAge,
  });

  @override
  _AddTaskToDatabaseState createState() => _AddTaskToDatabaseState();
}

class _AddTaskToDatabaseState extends State<AddTaskToDatabase> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the form if editing an existing task
    if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
    if (widget.initialAge != null) {
      _ageController.text = widget.initialAge!.toString();
    }
  }

  Future<void> _addOrUpdateTask() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final int age = int.tryParse(_ageController.text.trim()) ?? 0;

      if (widget.taskId == null) {
        // Add a new task
        await FirebaseFirestore.instance.collection('tasks').add({
          'name': name,
          'age': age,
        });
      } else {
        // Update an existing task
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .update({
          'name': name,
          'age': age,
        });
      }

      // Clear the form fields
      _nameController.clear();
      _ageController.clear();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.taskId == null
              ? 'Task added successfully!'
              : 'Task updated successfully!'),
        ),
      );

      // Navigate back to the task list
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name Input Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Age Input Field
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _addOrUpdateTask,
                child: Text(widget.taskId == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
