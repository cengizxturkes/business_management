import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../features/theme/data/models/theme_model.dart';
import '../../../../features/theme/data/repositories/theme_repository.dart';
import '../../../../core/services/theme_service.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  final String token;

  const HomePage({
    super.key,
    required this.user,
    required this.token,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeModel? _currentTheme;
  StreamSubscription? _themeSubscription;

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _subscribeToThemeChanges();
  }

  @override
  void dispose() {
    _themeSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await ThemeService.getTheme();
    if (savedTheme != null && mounted) {
      setState(() {
        _currentTheme = savedTheme;
      });
    }
  }

  void _subscribeToThemeChanges() {
    if (widget.user.branchId.isEmpty) return;

    _themeSubscription =
        ThemeRepository.subscribeToThemeChanges(widget.user.branchId).listen(
      (theme) async {
        debugPrint('Yeni tema alındı: ${theme.toString()}');
        try {
          await ThemeService.saveTheme(theme);
          if (mounted) {
            setState(() {
              _currentTheme = theme;
            });
            if (context.mounted) {
              Future.microtask(() {
                setState(() {});
              });
            }
          }
        } catch (e) {
          debugPrint('Tema kaydetme hatası: $e');
        }
      },
      onError: (error) {
        debugPrint('Tema subscription hatası: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _currentTheme != null
              ? _hexToColor(_currentTheme!.primaryColor)
              : AppColors.primary,
          surface: _currentTheme != null
              ? _hexToColor(_currentTheme!.backgroundColor)
              : AppColors.background,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: _currentTheme != null
                  ? _hexToColor(_currentTheme!.textColor)
                  : AppColors.dark,
              displayColor: _currentTheme != null
                  ? _hexToColor(_currentTheme!.textColor)
                  : AppColors.dark,
            ),
      ),
      child: Scaffold(
        backgroundColor: _currentTheme != null
            ? _hexToColor(_currentTheme!.backgroundColor)
            : AppColors.background,
        appBar: AppBar(
          backgroundColor: _currentTheme != null
              ? _hexToColor(_currentTheme!.backgroundColor)
              : AppColors.background,
          elevation: 0,
          title: Text(
            'Ana Sayfa',
            style: TextStyle(
              color: _currentTheme != null
                  ? _hexToColor(_currentTheme!.textColor)
                  : AppColors.dark,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.dark),
              onPressed: () async {
                await AuthService.logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hoş geldiniz,',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.dark50,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.user.firstName} ${widget.user.lastName}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.dark75,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.user.role.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Hızlı İşlemler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildQuickActionCard(
                    icon: Icons.assessment,
                    title: 'Raporlar',
                    color: AppColors.primary,
                    onTap: () {
                      // TODO: Navigate to reports
                    },
                  ),
                  _buildQuickActionCard(
                    icon: Icons.people,
                    title: 'Müşteriler',
                    color: Colors.blue,
                    onTap: () {
                      // TODO: Navigate to customers
                    },
                  ),
                  _buildQuickActionCard(
                    icon: Icons.inventory,
                    title: 'Ürünler',
                    color: Colors.orange,
                    onTap: () {
                      // TODO: Navigate to products
                    },
                  ),
                  _buildQuickActionCard(
                    icon: Icons.settings,
                    title: 'Ayarlar',
                    color: Colors.grey,
                    onTap: () {
                      // TODO: Navigate to settings
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
