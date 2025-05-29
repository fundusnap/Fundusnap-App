import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/core/services/azure_prediction_service.dart';
import 'package:gap/gap.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedImageFile;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();
  final AzurePredictionService _predictionService = AzurePredictionService();

  Future<void> _pickImageFromGallery() async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });
    try {
      final XFile? pickedXFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedXFile != null) {
        setState(() {
          _selectedImageFile = File(pickedXFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
      debugPrint("Error picking image: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImageFile == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final Map<String, dynamic>? predictionResult = await _predictionService
          .predictImage(_selectedImageFile!);

      if (mounted) {
        if (predictionResult != null) {
          debugPrint('-----------------------------------------');
          debugPrint('✅ Azure Prediction Successful (Upload Screen):');
          debugPrint('$predictionResult');
          debugPrint('-----------------------------------------');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Prediction successful! Check console for details.',
              ),
              backgroundColor: Colors.green,
            ),
          );
          // TODO: Later, navigate to a results screen
          // GoRouter.of(context).pushNamed(Routes.results, extra: predictionResult);

          setState(() {
            _selectedImageFile = null;
          });
        } else {
          debugPrint(
            '❌ Azure Prediction Failed or returned null (Upload Screen).',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not get prediction. Please try again.'),
              backgroundColor: AppColors.paleCarmine,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Error during prediction call (Upload Screen): $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: AppColors.paleCarmine,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Fundus Image'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color:
                Theme.of(context).appBarTheme.foregroundColor ??
                AppColors.white,
          ), // Use theme color or default
          onPressed: () {
            if (!_isProcessing) {
              //?  Prevent popping while processing
              GoRouter.of(context).pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Select Image from Gallery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.angelBlue,
                  foregroundColor: AppColors.bleachedCedar,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: _isProcessing ? null : _pickImageFromGallery,
              ),
              const Gap(20),
              Expanded(
                child: Center(
                  child: _isProcessing && _selectedImageFile == null
                      ? const CircularProgressIndicator(
                          color: AppColors.veniceBlue,
                        )
                      : _selectedImageFile != null
                      ? Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.gray, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              7,
                            ), // Slightly less than container
                            child: Image.file(
                              _selectedImageFile!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.gray.withAlpha(122),
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.white.withAlpha(204),
                          ),
                          child: const Center(
                            child: Text(
                              'No image selected.',
                              style: TextStyle(
                                color: AppColors.gray,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              const Gap(20),
              if (_selectedImageFile != null)
                ElevatedButton.icon(
                  icon: _isProcessing
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.analytics_outlined),
                  label: Text(_isProcessing ? 'Analyzing...' : 'Analyze Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.veniceBlue,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _isProcessing ? null : _analyzeImage,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
