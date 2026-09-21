import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';

/// Светящийся шар из логотипа старого «Портала». Пульсирует, если [animate].
class Orb extends StatefulWidget {
  const Orb({super.key, this.size = 120, this.color = AppColors.glow, this.animate = true});

  final double size;
  final Color color;
  final bool animate;

  /// Бесконечная пульсация не даёт тестам дождаться покоя — там её выключают.
  static bool pulse = true;

  @override
  State<Orb> createState() => _OrbState();
}

class _OrbState extends State<Orb> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600));

  @override
  void initState() {
    super.initState();
    if (widget.animate && Orb.pulse) _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_c.value);
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.95),
                  AppColors.glowLight.withValues(alpha: 0.85),
                  widget.color.withValues(alpha: 0.55 + 0.15 * t),
                  widget.color.withValues(alpha: 0),
                ],
                stops: [0, 0.14 + 0.03 * t, 0.42 + 0.06 * t, 1],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Звёздное небо: неподвижные точки, раскиданные детерминированно.
class StarField extends StatelessWidget {
  const StarField({super.key, this.density = 60});

  final int density;

  @override
  Widget build(BuildContext context) =>
      IgnorePointer(child: CustomPaint(painter: _StarPainter(density), size: Size.infinite));
}

class _StarPainter extends CustomPainter {
  _StarPainter(this.density);
  final int density;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7);
    final paint = Paint();
    for (var i = 0; i < density; i++) {
      final r = rnd.nextDouble() * 1.1 + 0.3;
      paint.color = Colors.white.withValues(alpha: rnd.nextDouble() * 0.5 + 0.15);
      canvas.drawCircle(Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) => old.density != density;
}

class NightCard extends StatelessWidget {
  const NightCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.accent,
    this.gradient,
    this.radius = 20,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? accent;
  final Gradient? gradient;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? AppColors.night2 : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: (accent ?? AppColors.nightLine).withValues(alpha: accent == null ? 1 : 0.5)),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Tap(onTap: onTap!, child: card);
  }
}

/// Кликабельная область с курсором-рукой.
class Tap extends StatelessWidget {
  const Tap({super.key, required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: MouseRegion(cursor: SystemMouseCursors.click, child: child),
      );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(this.text, {super.key, required this.onTap, this.enabled = true, this.gold = false, this.icon});

  final String text;
  final VoidCallback onTap;
  final bool enabled;
  final bool gold;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: enabled ? onTap : () {},
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1 : 0.4,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            gradient: gold
                ? const LinearGradient(colors: [Color(0xFFFFD98E), Color(0xFFF5A96B)])
                : AppGradients.cta,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (gold ? const Color(0xFFF5A96B) : AppColors.glow).withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: gold ? AppColors.night : Colors.white),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: gold ? AppColors.night : Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  const GhostButton(this.text, {super.key, required this.onTap, this.icon});

  final String text;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.nightLine),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 17, color: AppColors.star),
              const SizedBox(width: 8),
            ],
            Text(text, style: const TextStyle(color: AppColors.star, fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

/// Шапка внутреннего экрана: «назад», заголовок, действие справа.
class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.title, this.back = true, this.trailing});

  final String title;
  final bool back;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            if (back)
              Tap(
                onTap: AppState.instance.back,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.star),
                ),
              )
            else
              const SizedBox(width: 12),
            Expanded(child: Text(title, style: AppText.h3.copyWith(fontSize: 16), overflow: TextOverflow.ellipsis)),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class Pill extends StatelessWidget {
  const Pill(this.text, {super.key, this.color = AppColors.glow, this.filled = false, this.icon});

  final String text;
  final Color color;
  final bool filled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: filled ? AppColors.night : color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: filled ? AppColors.night : color,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 18, 2, 10),
        child: Row(
          children: [
            Expanded(child: Text(text.toUpperCase(), style: AppText.label)),
            ?trailing,
          ],
        ),
      );
}

/// Закрытый раздел: название видно, содержимое — нет.
class LockedRow extends StatelessWidget {
  const LockedRow(this.title, {super.key, this.subtitle, this.onTap});

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: NightCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_rounded, size: 15, color: AppColors.gold),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.h3.copyWith(fontSize: 14)),
                  if (subtitle != null) Text(subtitle!, style: AppText.small),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.star3),
          ],
        ),
      ),
    );
  }
}

/// Полоса величины: один цвет, трек — тот же цвет прозрачнее.
class ValueBar extends StatelessWidget {
  const ValueBar({super.key, required this.value, this.color = AppColors.glow, this.height = 6});

  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: color.withValues(alpha: 0.15))),
            FractionallySizedBox(
              widthFactor: value.clamp(0, 1),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.initials, required this.color, this.size = 48});

  final String initials;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, AppColors.night, 0.55)!],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        initials,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: size * 0.32),
      ),
    );
  }
}

/// Прокручиваемое тело экрана с отступами.
class ScreenBody extends StatelessWidget {
  const ScreenBody({super.key, required this.children, this.bottomPadding = 24});

  final List<Widget> children;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(18, 4, 18, bottomPadding),
      children: children,
    );
  }
}

void showDemoSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), duration: const Duration(seconds: 2)));
}
