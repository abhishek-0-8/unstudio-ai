import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:unstudio/ImageCapture/controller/image_capture_controller.dart';
import 'home/controllers/garment_controller.dart';
import 'ImageCapture/view/selfie_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({required this.cameras, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImageCaptureController(cameras: cameras),
        ),
        ChangeNotifierProvider(create: (_) => GarmentController()),
      ],
      child: MaterialApp(
        title: 'Selfie Capture',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: SelfieCaptureScreen(),
        // To test garment UI, use:
        // home: HomeScreen(),
      ),
    );
  }
}
