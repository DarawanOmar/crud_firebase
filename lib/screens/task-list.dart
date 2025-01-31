import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add-task.dart'; // Import the AddTaskToDatabase screen for editing

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  // Function to delete a task
  Future<void> _deleteTask(String taskId) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks Manager'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-task'),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tasks found.'));
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index].data() as Map<String, dynamic>;
              final taskId = tasks[index].id; // Get the document ID

              return ListTile(
                title: Text(task['name'] ?? 'No Name'),
                subtitle: Text('Age: ${task['age']?.toString() ?? '0'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit Button
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Navigate to the edit screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTaskToDatabase(
                              taskId: taskId,
                              initialName: task['name'],
                              initialAge: task['age'],
                            ),
                          ),
                        );
                      },
                    ),
                    // Delete Button
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Show a confirmation dialog before deleting
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Task'),
                            content: Text(
                                'Are you sure you want to delete this task?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteTask(taskId); // Delete the task
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
