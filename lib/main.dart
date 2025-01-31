import 'package:curd_firebase/screens/task-list.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/add-task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase for both Android and Web
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCxM-aZzyLIqECUTxJNXv1cy-UxlS3CQ40",
        authDomain: "crud-flutter-c32fd.firebaseapp.com",
        projectId: "crud-flutter-c32fd",
        storageBucket: "crud-flutter-c32fd.firebasestorage.app",
        messagingSenderId: "740521665639",
        appId: "1:740521665639:web:944d4cf579939c5f7ba0c2",
      ),
    );
    runApp(const MyApp(isFirebaseConnected: true));
  } catch (e) {
    runApp(const MyApp(isFirebaseConnected: false));
  }
}

class MyApp extends StatelessWidget {
  final bool isFirebaseConnected;
  const MyApp({super.key, required this.isFirebaseConnected});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase CRUD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TaskListScreen(),
        '/add-task': (context) => AddTaskToDatabase(),
      },
    );
  }
}
