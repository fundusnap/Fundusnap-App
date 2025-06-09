import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/fundus_ai/presentation/cubit/list/chat_list_cubit.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/fundus_ai_header.dart';

class FundusAiErrorState extends StatelessWidget {
  final String message;

  const FundusAiErrorState({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        const FundusAiHeader(title: "Connection Issue"),

        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.paleCarmine.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.cloud_off,
                      size: 64,
                      color: AppColors.paleCarmine,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Unable to Load Chat History',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.gray, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => context.read<ChatListCubit>().fetchChats(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.angelBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
