import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/prediction/presentation/cubit/create/create_prediction_cubit.dart';
import 'package:sugeye/features/prediction/presentation/cubit/list/prediction_list_cubit.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  // Local UI state to show loading indicators and disable buttons
  bool _isProcessing = false;

  Future<void> _analyzeImage() async {
    if (_isProcessing) return;

    // Call the cubit method. The BlocListener will handle the rest.
    context.read<CreatePredictionCubit>().createPrediction(
      File(widget.imagePath),
    );
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
          });

          // Print the result to the console for testing
          debugPrint('-----------------------------------------');
          debugPrint('✅ Prediction Success (DisplayPicture Screen):');
          debugPrint('Prediction ID: ${state.prediction.id}');
          debugPrint(
            'Top Prediction: ${state.prediction.predictions.first.tagName} (${(state.prediction.predictions.first.probability * 100).toStringAsFixed(2)}%)',
          );
          debugPrint('-----------------------------------------');
          // context.read<PredictionListCubit>().addNewPrediction(
          //   state.prediction,
          // );

          if (context.mounted) {
            // GoRouter.of(context).pop();
            try {
              GoRouter.of(
                context,
              ).pushNamed(Routes.cameraResult, extra: state.prediction);
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
        appBar: AppBar(title: const Text('Tinjau Gambar')),
        backgroundColor: AppColors.bleachedCedar,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(child: Image.file(File(widget.imagePath))),
              ),
              const Gap(13),
              Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ), // Changed from 0 to 16 for better spacing
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Retake'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gray,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: _isProcessing
                          ? null
                          : () => GoRouter.of(context).pop(),
                    ),
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
                          : const Icon(Icons.check_circle_outline),
                      label: Text(_isProcessing ? 'Analyzing...' : 'Use Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.veniceBlue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: _isProcessing ? null : _analyzeImage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
