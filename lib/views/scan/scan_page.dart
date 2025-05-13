import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'scan_result_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController? _controller;
  File? _imageFile;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();
      setState(() {
        _imageFile = File(image.path);
        _isAnalyzing = true;
      });
      _analyzeImage();
    } catch (e) {
      debugPrint("Error taking picture: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _isAnalyzing = true;
        });
        _analyzeImage();
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _analyzeImage() {
    if (_imageFile == null) return;

    // Simulate analysis delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isAnalyzing = false;
      });
    });

    int hash = _imageFile!.path.hashCode;
    final conditions = ['Berjerawat', 'Normal'];
    final skinTypes = ['Berminyak', 'Kering', 'Kombinasi'];
    final acneTypes = ['Jerawat Batu', 'Jerawat Kecil-kecil', 'Tidak Ada Jerawat'];

    final skinCondition = conditions[hash.abs() % conditions.length];
    final skinType = skinTypes[hash.abs() % skinTypes.length];
    final acneType = (skinCondition == 'Berjerawat')
        ? acneTypes[(hash.abs() ~/ conditions.length) % 2]
        : acneTypes[2];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          imageFile: _imageFile!,
          skinCondition: skinCondition,
          skinType: skinType,
          acneType: acneType,
        ),
      ),
    );
  }

  Widget _buildFacialPoints() {
    return CustomPaint(
      painter: FacialPointsPainter(),
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'AI Skin Health Analysis',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera Preview
          Container(
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: 1 / _controller!.value.aspectRatio,
              child: Transform.scale(
                scale: 1.5,
                child: Center(
                  child: CameraPreview(_controller!),
                ),
              ),
            ),
          ),

          // Facial Points Overlay
          if (!_isAnalyzing)
            CustomPaint(
              painter: FacialPointsPainter(),
              child: Container(),
            ),

          // Loading Indicator
          if (_isAnalyzing)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
                
          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: 50, left: 20, right: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center Selfie Button
                  Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        onPressed: _takePicture,
                        icon: const Icon(Icons.camera, color: Colors.black, size: 38),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  // Upload Button (Right Side)
                  Positioned(
                    right: 50,
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        color: Colors.white.withOpacity(0.15),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.photo_library_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isActive) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        if (isActive)
          Container(
            height: 2,
            width: 40,
            color: Colors.white,
          ),
      ],
    );
  }

  Widget _buildProductCard(String title, String price, String originalPrice) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                originalPrice,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FacialPointsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw facial recognition points
    final points = [
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.5),
      Offset(size.width * 0.3, size.height * 0.7),
      Offset(size.width * 0.7, size.height * 0.7),
    ];

    for (var point in points) {
      canvas.drawCircle(point, 3, paint);
    }

    // Draw connecting lines
    canvas.drawPath(
      Path()
        ..moveTo(points[0].dx, points[0].dy)
        ..lineTo(points[1].dx, points[1].dy)
        ..lineTo(points[4].dx, points[4].dy)
        ..lineTo(points[3].dx, points[3].dy)
        ..lineTo(points[0].dx, points[0].dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
