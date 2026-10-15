import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../models/app_user.dart';
import '../../models/worker_profile.dart';
import '../../state/auth_scope.dart';

/// Screen 6 - worker dashboard landing.
///
/// Part 1 hands off here with a signed-in worker. Person 2 replaces the
/// placeholder sections below with profile completion, jobs and skills.
class WorkerDashboardScreen extends StatelessWidget {
  const WorkerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthScope.of(context).currentUser;

    if (user == null) {
      return const _SignedOutGuard();
    }

    final WorkerProfile? profile = user.workerProfile;
    final int completion = _completion(profile);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _DashboardHeader(
              user: user,
              subtitle: 'Worker account',
              onSignOut: () => _signOut(context),
            ),
            Transform.translate(
              offset: const Offset(0, -28),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileCompletionCard(
                      percent: completion,
                      profile: profile,
                    ),
                    const SizedBox(height: 20),
                    const _SectionTitle('Quick actions'),
                    const SizedBox(height: 12),
                    const _PlaceholderGrid(
                      items: <_Placeholder>[
                        _Placeholder(
                          icon: Icons.work_outline_rounded,
                          label: 'Find jobs',
                          note: 'Person 4',
                        ),
                        _Placeholder(
                          icon: Icons.assignment_turned_in_outlined,
                          label: 'My applications',
                          note: 'Person 4',
                        ),
                        _Placeholder(
                          icon: Icons.event_available_outlined,
                          label: 'Bookings',
                          note: 'Person 4',
                        ),
                        _Placeholder(
                          icon: Icons.workspace_premium_outlined,
                          label: 'Badges',
                          note: 'Person 5',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle('Your skills'),
                    const SizedBox(height: 12),
                    if (profile != null && profile.skills.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.skills
                            .map(
                              (skill) => Chip(
                                label: Text(skill),
                                backgroundColor: Colors.white,
                              ),
                            )
                            .toList(),
                      )
                    else
                      const _EmptyNote(
                        'Add your skills in profile setup to appear in searches.',
                      ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static int _completion(WorkerProfile? profile) {
    if (profile == null) return 0;
    int score = 0;
    if (profile.trade?.isNotEmpty ?? false) score += 30;
    if (profile.bio?.isNotEmpty ?? false) score += 25;
    if (profile.location?.isNotEmpty ?? false) score += 20;
    if (profile.skills.isNotEmpty) score += 25;
    return score;
  }

  void _signOut(BuildContext context) {
    AuthScope.read(context).signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.splash,
      (route) => false,
    );
  }
}

class _ProfileCompletionCard extends StatelessWidget {
  const _ProfileCompletionCard({required this.percent, required this.profile});

  final int percent;
  final WorkerProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Profile completion',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const Spacer(),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 10,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.navy,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              profile?.trade == null
                  ? 'Complete your profile to start winning jobs.'
                  : '${profile!.trade} • ${profile!.location ?? "Location"}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            const Text(
              'Detail screens (portfolio, services) are built in Person 3.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.user,
    required this.subtitle,
    required this.onSignOut,
  });

  final AppUser user;
  final String subtitle;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
      decoration: const BoxDecoration(gradient: AppColors.navyGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Text(
                  user.initials,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${user.firstName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onSignOut,
                tooltip: 'Sign out',
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user_outlined,
                    color: AppColors.accent, size: 16),
                SizedBox(width: 8),
                Text(
                  'Signed in successfully',
                  style: TextStyle(color: Colors.white, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class _Placeholder {
  const _Placeholder({
    required this.icon,
    required this.label,
    required this.note,
  });

  final IconData icon;
  final String label;
  final String note;
}

class _PlaceholderGrid extends StatelessWidget {
  const _PlaceholderGrid({required this.items});

  final List<_Placeholder> items;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: items
          .map(
            (item) => Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon, color: AppColors.navy),
                  const Spacer(),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.note,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

class _SignedOutGuard extends StatelessWidget {
  const _SignedOutGuard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline_rounded,
                  size: 48, color: AppColors.navy),
              const SizedBox(height: 16),
              const Text(
                'You are signed out.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in again to access your dashboard.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.signIn,
                  (route) => false,
                ),
                child: const Text('Go to sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
