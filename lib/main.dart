import 'package:arabic/bloc.dart';
import 'package:arabic/core/di/injection.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/core/theme/theme.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/features/splash/presentation/view/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  await initializeDependencies();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Pre-warm the TTS engine in the background so the first quiz speak() is instant.
  // This is intentionally unawaited — it must not block the app from launching.
  TtsService().warmUp();

  // Load saved language or default to 'ar'
  final savedLanguage = await LocalStorage.getLanguage();
  final startLocale = Locale(savedLanguage ?? 'en');

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        // Locale('ar'),
        Locale('fr'),
        Locale('de'),
        Locale('zh'),
        Locale('ru'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: startLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Get the physical size and pixel ratio to determine logical width/height
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    final width = size.width;
    final height = size.height;

    // Determine device type based on shortest side
    final shortestSide = size.shortestSide;
    final isTablet = shortestSide > 600;
    final isLandscape = width > height;

    // Define Design Sizes (Reference)
    // Phone: iPhone 14 Pro (393 x 852)
    // Tablet: iPad Pro 11" (834 x 1194)
    Size designSize;

    if (isTablet) {
      designSize = isLandscape ? const Size(1194, 834) : const Size(834, 1194);
    } else {
      designSize = isLandscape ? const Size(852, 393) : const Size(393, 852);
    }

    return GenerateMultiBloc(
      child: ScreenUtilInit(
        designSize: designSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return RepaintBoundary(
            child: MaterialApp(
              navigatorKey: navigator,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: 'Qalam Arabic',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme,
              home: SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
