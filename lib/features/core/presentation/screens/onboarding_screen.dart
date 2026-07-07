import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Onboarding en 3 étapes + écran connexion.
/// Design épuré, animations fluides, vrai rendu app.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;
  int _currentPage = 0;

  static const _totalPages = 4;

  final List<_SlideData> _slides = [
    _SlideData(
      icon: Icons.local_hospital_rounded,
      title: 'Hôpitaux & Cliniques',
      description:
          'Trouvez les établissements de santé partenaires autour de vous, explorez leurs services en un coup d\'œil.',
      color: const Color(0xFF1565C0),
      lightColor: const Color(0xFFE3F2FD),
    ),
    _SlideData(
      icon: Icons.calendar_month_rounded,
      title: 'Rendez-vous Médicaux',
      description:
          'Réservez une consultation en ligne avec le médecin de votre choix, sans attente et sans stress.',
      color: const Color(0xFF00897B),
      lightColor: const Color(0xFFE0F2F1),
    ),
    _SlideData(
      icon: Icons.science_rounded,
      title: 'Résultats & Suivi',
      description:
          'Accédez à vos résultats d\'analyses, recevez vos comptes rendus et suivez votre historique médical.',
      color: const Color(0xFF7B1FA2),
      lightColor: const Color(0xFFF3E5F5),
    ),
    _SlideData(
      icon: Icons.rocket_launch_rounded,
      title: 'Tout donner !',
      description:
          'Connectez-vous pour profiter de toutes les fonctionnalités et gérer votre santé au quotidien.',
      color: const Color(0xFF1565C0),
      lightColor: const Color(0xFFE3F2FD),
      isLast: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => _SlideWidget(
              slide: _slides[i],
              isActive: i == _currentPage,
              floatAnimation: _floatAnimation,
            ),
          ),

          // Header
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.health_and_safety, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Hopitel',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  if (_currentPage < _totalPages - 1)
                    GestureDetector(
                      onTap: () => _pageController.jumpToPage(_totalPages - 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                        ),
                        child: Text(
                          'Passer',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom section
          Positioned(
            bottom: bottomPadding + 20,
            left: 0,
            right: 0,
            child: _currentPage < _totalPages - 1
                ? _buildBottomNav()
                : _buildLoginSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_totalPages - 1, (i) {
            final isActive = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: isActive ? 32 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 28),
        // Next button
        GestureDetector(
          onTap: () => _pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          ),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: _slides[_currentPage].color,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Suivant',
          style: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: FilledButton.icon(
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.person, size: 22),
            label: Text(
              'Se connecter',
              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1565C0),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              shadowColor: const Color(0xFF1565C0).withValues(alpha: 0.3),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Pas encore de compte ? ",
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/register'),
              child: Text(
                "S'inscrire",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Slide individuelle
// ─────────────────────────────────────────────────────────────────

class _SlideWidget extends StatelessWidget {
  final _SlideData slide;
  final bool isActive;
  final Animation<double> floatAnimation;

  const _SlideWidget({
    required this.slide,
    required this.isActive,
    required this.floatAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            slide.color,
            slide.color.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Cercle décoratif 1 (grand, haut-droit)
          Positioned(
            top: -size.width * 0.25,
            right: -size.width * 0.15,
            child: Container(
              width: size.width * 0.75,
              height: size.width * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          // Cercle décoratif 2 (moyen, bas-gauche)
          Positioned(
            bottom: -size.width * 0.35,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          // Petit cercle décoratif
          Positioned(
            top: size.height * 0.12,
            right: 40,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          // Petit cercle décoratif 2
          Positioned(
            bottom: size.height * 0.25,
            left: 30,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          // Contenu
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Icône avec flottement
                AnimatedBuilder(
                  animation: floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, floatAnimation.value),
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: isActive ? 1.0 : 0.6,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(slide.icon, color: Colors.white, size: 56),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Titre
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    slide.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description (sans \n forcés)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    slide.description,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Données d'une slide
// ─────────────────────────────────────────────────────────────────

class _SlideData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color lightColor;
  final bool isLast;

  const _SlideData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.lightColor,
    this.isLast = false,
  });
}
