import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// SkillBridge logo mark: a rounded navy tile with a bridge glyph.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 72,
    this.showRing = true,
    this.onDark = false,
  });

  final double size;
  final bool showRing;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final Widget tile = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: onDark ? null : AppColors.navyGradient,
        color: onDark ? Colors.white : null,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        Icons.handshake_rounded,
        size: size * 0.5,
        color: onDark ? AppColors.navy : AppColors.accent,
      ),
    );

    if (!showRing) return tile;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.navy.withValues(alpha: 0.06),
      ),
      child: tile,
    );
  }
}
