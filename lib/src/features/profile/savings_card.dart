import 'package:flutter/material.dart';
import 'package:teardrop/src/data/models/app_user.dart';
import 'package:teardrop/src/data/services/tear_savings_service.dart';
import 'package:teardrop/src/theme.dart';

class SavingsCard extends StatelessWidget {
  const SavingsCard({super.key, required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final savings = TearSavingsService.calculate(
      totalReactions: user.totalReactions,
      averageTearRating: user.averageTearRating,
      totalVideosWatched: user.totalVideosWatched,
      joinedAt: user.createdAt,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF0FDF4),
              const Color(0xFFECFDF5).withValues(alpha: 0.5),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.savings_outlined,
                      color: Color(0xFF16A34A),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '아낀 인공눈물 비용',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TearDropTheme.textPrimary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      TearSavingsService.formatKrw(savings.totalSavingsKrw),
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF16A34A),
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${savings.daysSinceJoined}일간 절약한 금액',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TearDropTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _DetailRow(
                icon: Icons.water_drop_outlined,
                label: '자연 눈물',
                value: '${savings.totalNaturalDrops}방울',
              ),
              const SizedBox(height: 10),
              _DetailRow(
                icon: Icons.local_pharmacy_outlined,
                label: '인공눈물 절약',
                value: '약 ${savings.bottlesSaved.toStringAsFixed(1)}병',
              ),
              const SizedBox(height: 10),
              _DetailRow(
                icon: Icons.trending_up_rounded,
                label: '월 예상 절약',
                value: TearSavingsService.formatKrw(savings.monthlySavingsKrw),
              ),
              const SizedBox(height: 10),
              _DetailRow(
                icon: Icons.calendar_month_outlined,
                label: '연간 예상 절약',
                value: TearSavingsService.formatKrw(savings.yearlySavingsKrw),
                highlight: true,
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: TearDropTheme.border.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 13, color: TearDropTheme.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '인공눈물 15mL 기준 약 8,000원, 1방울 약 213원으로 추정',
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: TearDropTheme.textSecondary,
                                  fontSize: 10,
                                ),
                      ),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: highlight
              ? const Color(0xFF16A34A)
              : TearDropTheme.textSecondary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TearDropTheme.textSecondary,
                ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
                color: highlight
                    ? const Color(0xFF16A34A)
                    : TearDropTheme.textPrimary,
              ),
        ),
      ],
    );
  }
}
