import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teardrop/src/app_router.dart';
import 'package:teardrop/src/widgets/responsive_center.dart';

/// Landing page with medical/pharmaceutical design.
/// "Start Therapy" button unlocks Audio Context for Web autoplay.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFBBDEFB),
              Color(0xFF90CAF9),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: ResponsiveCenter(
            maxWidth: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                _buildLogo(context),
                const SizedBox(height: 24),
                _buildHeadline(context),
                const SizedBox(height: 16),
                _buildSubheadline(context),
                const Spacer(flex: 2),
                _buildStartButton(context),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.water_drop_rounded,
        size: 48,
        color: Color(0xFF1565C0),
      ),
    );
  }

  Widget _buildHeadline(BuildContext context) {
    return Text(
      'Digital Prescription for Dry Eyes',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D47A1),
            letterSpacing: -0.5,
          ),
    );
  }

  Widget _buildSubheadline(BuildContext context) {
    return Text(
      '안구건조증을 위한 디지털 처방전',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFF1565C0).withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.go(AppRoutes.player);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: const Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFF1565C0).withOpacity(0.4),
        ),
        child: const Text('Start Therapy'),
      ),
    );
  }
}
