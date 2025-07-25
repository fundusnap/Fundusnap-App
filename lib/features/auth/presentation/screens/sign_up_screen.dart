import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/core/extensions/snackbar_extension.dart';
import 'package:sugeye/features/auth/presentation/cubit/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      context.read<AuthCubit>().signUpWithEmail(
        email: email,
        password: password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,

      // resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,

      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            context.customShowErrorSnackBar(state.message);
          }
        },
        child:
            // Center(
            // child:
            // SingleChildScrollView(
            ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 20.0,
              ),
              children: [
                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Gap(10),
                        Container(
                          height: 210,
                          alignment: Alignment.center,
                          child: Image.asset("assets/logos/android12-logo.png"),
                        ),
                        const Gap(10),
                        Text(
                          'Sign Up',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: AppColors.veniceBlue,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),

                        const Gap(20),

                        //?  email Field
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(
                            color: AppColors.bleachedCedar,
                          ),
                          decoration: _inputDecoration(
                            labelText: "Email",
                            hintText: "Enter your email",
                            icon: Icons.email_outlined,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const Gap(20),

                        //?  password Field
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(
                            color: AppColors.bleachedCedar,
                          ),
                          decoration: _inputDecoration(
                            labelText: "Create password",
                            hintText: "Create your password",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: _obscurePassword,
                            onObscureToggle: () => setState(() {
                              _obscurePassword = !_obscurePassword;
                            }),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const Gap(20),
                        //? confirm password field
                        TextFormField(
                          controller: _confirmPasswordController,
                          style: const TextStyle(
                            color: AppColors.bleachedCedar,
                          ),
                          decoration: _inputDecoration(
                            labelText: "Confirm password",
                            hintText: 'Confirm your password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: _obscureConfirmPassword,
                            onObscureToggle: () => setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            }),
                          ),
                          obscureText: _obscureConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        const Gap(25),

                        //?  submit Button
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: AppColors.angelBlue,
                                foregroundColor: AppColors.bleachedCedar,
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                        const Gap(20),

                        // ? toggle Sign Up
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: AppColors.bleachedCedar.withAlpha(179),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                GoRouter.of(
                                  context,
                                ).goNamed(Routes.signInScreen);
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: AppColors.veniceBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ),
      // ),
      // ),
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onObscureToggle,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.bleachedCedar.withAlpha(122)),
      prefixIcon: Icon(icon, color: AppColors.bleachedCedar),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.bleachedCedar,
              ),
              onPressed: onObscureToggle,
            )
          : null,
      filled: true,
      fillColor: AppColors.white.withAlpha(122),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.veniceBlue, width: 1.8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.angelBlue, width: 2.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.paleCarmine, width: 1.8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.paleCarmine, width: 1.8),
      ),
    );
  }
}
