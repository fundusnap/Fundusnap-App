import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:gap/gap.dart';
// import 'package:sugeye/features/auth/domain/repositories/auth_repository.dart';
import 'package:sugeye/features/prediction/presentation/cubit/create/create_prediction_cubit.dart';
import 'package:sugeye/features/prediction/presentation/cubit/list/prediction_list_cubit.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedImageFile;
  bool _isProcessing = false; // We still use this to control the UI
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    if (_isProcessing) return;
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
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImageFile == null || _isProcessing) return;

    context.read<CreatePredictionCubit>().createPrediction(_selectedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePredictionCubit, CreatePredictionState>(
      listener: (context, state) {
        if (state is CreatePredictionLoading) {
          setState(() {
            _isProcessing = true;
          });
        } else if (state is CreatePredictionSuccess) {
          setState(() {
            _isProcessing = false;
            // ?  clear the image after a successful prediction
            _selectedImageFile = null;
          });

          debugPrint('-----------------------------------------');
          debugPrint('✅ Prediction Success (via Cubit):');
          debugPrint('Prediction ID: ${state.prediction.id}');
          debugPrint(
            'Top Prediction: ${state.prediction.predictions.first.tagName} (${(state.prediction.predictions.first.probability * 100).toStringAsFixed(2)}%)',
          );
          debugPrint('-----------------------------------------');
          // context.read<PredictionListCubit>().addNewPrediction(
          //   state.prediction,
          // );
          if (context.mounted) {
            try {
              GoRouter.of(
                context,
              ).pushNamed(Routes.uploadResult, extra: state.prediction);
              // ).goNamed(Routes.uploadResult, extra: state.prediction);
              debugPrint('✅ Navigation call successful');
            } catch (e) {
              debugPrint('❌ Navigation failed: $e');
            }
          }
        } else if (state is CreatePredictionError) {
          setState(() {
            _isProcessing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Prediction failed: ${state.message}'),
              backgroundColor: AppColors.paleCarmine,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('Upload Fundus Image'),
          title: const Text('Unggah Gambar'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color:
                  Theme.of(context).appBarTheme.foregroundColor ??
                  AppColors.white,
            ),
            onPressed: () {
              if (!_isProcessing) {
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
                  label: const Text('Pilih Gambar dari Galeri'),
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
                    // ? UI for the image preview
                    child: _selectedImageFile != null
                        ? Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.gray,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
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
                                'Tidak ada gambar yang dipilih.',
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
                    // ?UI for the button  uses _isProcessing
                    //? controlled by the BlocListener.
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
                    label: Text(
                      _isProcessing ? 'Menganalisis...' : 'Analisis Gambar',
                    ),
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
      ),
    );
  }
}
