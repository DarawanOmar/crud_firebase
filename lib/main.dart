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
          apiKey: "AIzaSyC_uJsBVu9QFJgOQDMLvSCP0CUf2gzFX2s",
          authDomain: "crud-app-d4681.firebaseapp.com",
          projectId: "crud-app-d4681",
          storageBucket: "crud-app-d4681.firebasestorage.app",
          messagingSenderId: "369765830523",
          appId: "1:369765830523:web:226a3f6c632be16b3c77de"),
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
