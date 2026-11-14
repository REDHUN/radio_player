import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';
import 'providers/favorites_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/radio_player_provider.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize background audio service for lock screen & notification controls (Play, Next, Prev)
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.malayalam_radio.channel.audio',
    androidNotificationChannelName: 'Malayalam Radio Playback',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
    androidNotificationIcon: 'mipmap/ic_launcher',
    notificationColor: AppColors.primaryPink,
  );

  // Set immersive dark system UI styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MalayalamRadioApp());
}

class MalayalamRadioApp extends StatelessWidget {
  const MalayalamRadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RadioPlayerProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'Malayalam Radio',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primaryPink,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primaryPink,
            secondary: AppColors.primaryPurple,
            surface: AppColors.surface,
          ),
          useMaterial3: true,
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}
