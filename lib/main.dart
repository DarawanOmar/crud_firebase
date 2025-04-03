import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:curd_firebase/screens/task-list.dart';
import './screens/add-task.dart';

// aa
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async main function

  try {
    // Load the .env file
    await dotenv.load(fileName: ".env");

    // Initialize Firebase
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['API_KEY']!,
        authDomain: dotenv.env['AUTH_DOMAIN']!,
        projectId: dotenv.env['PROJECT_ID']!,
        storageBucket: dotenv.env['STORAGE_BUCKET']!,
        messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
        appId: dotenv.env['APP_ID']!,
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
