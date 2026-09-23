import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';

enum RecognitionMode { hand, face }

class SignToTextScreen extends StatefulWidget {
  const SignToTextScreen({super.key});

  @override
  State<SignToTextScreen> createState() => _SignToTextScreenState();
}

class _SignToTextScreenState extends State<SignToTextScreen> {
  late CameraController _controller;
  Interpreter? handInterpreter;
  Interpreter? faceInterpreter;
  List<String> handLabels = [];
  List<String> faceLabels = [];
  String predictionResult = "Waiting...";
  FlutterTts tts = FlutterTts();
  bool isProcessing = false;
  final int inputSize = 64; // Change if your model expects a different size
  RecognitionMode mode = RecognitionMode.hand;

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModelsAndLabels();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    if (mounted) {
      setState(() {});
      startFrameStream();
    }
  }

  Future<void> loadModelsAndLabels() async {
    handInterpreter = await Interpreter.fromAsset('models/isl_model.tflite');
    handLabels = await _loadLabels('assets/models/labels.txt');
    // For facial gestures, provide your own model and labels
    try {
      faceInterpreter = await Interpreter.fromAsset('models/face_model.tflite');
      faceLabels = await _loadLabels('assets/models/face_labels.txt');
    } catch (_) {
      // If you don't have a face model, ignore
      faceInterpreter = null;
      faceLabels = [];
    }
    debugPrint("Models and Labels Loaded ✅");
  }

  Future<List<String>> _loadLabels(String path) async {
    final raw = await rootBundle.loadString(path);
    return raw
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void startFrameStream() {
    _controller.startImageStream((CameraImage image) async {
      if (!isProcessing &&
          handInterpreter != null &&
          (mode == RecognitionMode.hand || faceInterpreter != null)) {
        isProcessing = true;
        try {
          final input = await _convertCameraImage(image);
          final numLabels = mode == RecognitionMode.hand
              ? handLabels.length
              : faceLabels.length;
          final output = List.filled(numLabels, 0.0).reshape([1, numLabels]);
          if (mode == RecognitionMode.hand) {
            handInterpreter!.run(input, output);
          } else {
            faceInterpreter!.run(input, output);
          }
          final prediction = output[0];
          final maxIdx = prediction.indexOf(
            prediction.reduce((a, b) => a > b ? a : b),
          );
          final result = (mode == RecognitionMode.hand
              ? handLabels[maxIdx]
              : faceLabels[maxIdx]);
          setState(() {
            predictionResult = result;
          });
          await tts.speak(result);
        } catch (e) {
          debugPrint("❌ Error: $e");
        }
        isProcessing = false;
      }
    });
  }

  Future<List<List<List<List<double>>>>> _convertCameraImage(
    CameraImage image,
  ) async {
    final imglib.Image rgbImage = _convertYUV420ToImage(image);
    final imglib.Image resized = imglib.copyResize(
      rgbImage,
      width: inputSize,
      height: inputSize,
    );
    final input = List.generate(
      inputSize,
      (y) => List.generate(inputSize, (x) {
        final pixel = resized.getPixel(x, y);
        return [
          pixel.r / 255.0, // Red
          pixel.g / 255.0, // Green
          pixel.b / 255.0, // Blue
        ];
      }),
    );
    return [input];
  }

  imglib.Image _convertYUV420ToImage(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final uvRowStride = image.planes[1].bytesPerRow;
    final uvPixelStride = image.planes[1].bytesPerPixel!;
    final img = imglib.Image(width: width, height: height);
    for (int y = 0; y < height; y++) {
      final int uvRow = uvRowStride * (y >> 1);
      for (int x = 0; x < width; x++) {
        final int uvIndex = uvRow + (x >> 1) * uvPixelStride;
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes.length > uvIndex
            ? image.planes[1].bytes[uvIndex]
            : 128;
        final vp = image.planes[2].bytes.length > uvIndex
            ? image.planes[2].bytes[uvIndex]
            : 128;
        int r = (yp + 1.370705 * (vp - 128)).clamp(0, 255).toInt();
        int g = (yp - 0.337633 * (up - 128) - 0.698001 * (vp - 128))
            .clamp(0, 255)
            .toInt();
        int b = (yp + 1.732446 * (up - 128)).clamp(0, 255).toInt();
        img.setPixelRgba(x, y, r, g, b, 255);
      }
    }
    return img;
  }

  @override
  void dispose() {
    _controller.dispose();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign/Face to Text/Speech"),
        actions: [
          PopupMenuButton<RecognitionMode>(
            onSelected: (RecognitionMode selected) {
              setState(() {
                mode = selected;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: RecognitionMode.hand,
                child: Text('Hand Gesture'),
              ),
              const PopupMenuItem(
                value: RecognitionMode.face,
                child: Text('Facial Gesture'),
              ),
            ],
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            )
          else
            const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 20),
          Text(
            "Prediction: $predictionResult",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "Mode: ${mode == RecognitionMode.hand ? "Hand Gesture" : "Facial Gesture"}",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
