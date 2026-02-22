import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teardrop/src/features/auth/auth_providers.dart';
import 'package:teardrop/src/shared/widgets/responsive_center.dart';
import 'package:teardrop/src/theme.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  bool _loading = false;

  Future<void> _startTherapy() async {
    setState(() => _loading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInAnonymously();
    } catch (e) {
      debugPrint('Auth failed (placeholder Firebase): $e');
    }
    if (mounted) {
      setState(() => _loading = false);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.4, 0.8, 1.0],
            colors: [
              Color(0xFFF0F5FF),
              Color(0xFFE8F0FE),
              Color(0xFFDBEAFE),
              Color(0xFFF8FAFC),
            ],
          ),
        ),
        child: SafeArea(
          child: ResponsiveCenter(
            maxWidth: 420,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 3),
                _buildLogo()
                    .animate()
                    .fadeIn(duration: 700.ms)
                    .scale(begin: const Offset(0.85, 0.85)),
                const SizedBox(height: 32),
                _buildHeadline(context)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.15),
                const SizedBox(height: 12),
                _buildSubheadline(context)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 350.ms),
                const SizedBox(height: 8),
                _buildDescription(context)
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 500.ms),
                const Spacer(flex: 3),
                _buildStartButton(context)
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 650.ms)
                    .slideY(begin: 0.2),
                const SizedBox(height: 12),
                _buildDisclaimer(context)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 800.ms),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: TearDropTheme.primary.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.water_drop_rounded,
        size: 44,
        color: TearDropTheme.primary,
      ),
    );
  }

  Widget _buildHeadline(BuildContext context) {
    return Text(
      'Teary',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: TearDropTheme.textPrimary,
            letterSpacing: -1.0,
          ),
    );
  }

  Widget _buildSubheadline(BuildContext context) {
    return Text(
      '안구건조증을 위한 디지털 처방전',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: TearDropTheme.primary,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        '감동 영상으로 자연스러운 눈물을 유도하여\n눈 건강을 지켜드립니다',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: TearDropTheme.textSecondary,
              height: 1.5,
            ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loading ? null : _startTherapy,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('시작하기'),
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    return Text(
      '로그인 없이 바로 시작할 수 있어요',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: TearDropTheme.textSecondary.withValues(alpha: 0.7),
          ),
    );
  }
}
