import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shikidev/src/utils/extensions/buildcontext.dart';

import '../constants/box_types.dart';
import '../constants/hive_keys.dart';
import '../utils/router.dart';
import 'providers/environment_provider.dart';
import 'widgets/app_theme_builder.dart';

// const _appMainColor = Colors.orange;
// bool monetUI = true;

String appTitle = kDebugMode ? 'ShikiDev' : 'ShikiWatch';

class ShikiApp extends ConsumerWidget {
  const ShikiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(environmentProvider);

    final isDarkMode = context.brightness == Brightness.dark;
    final brightness = isDarkMode ? Brightness.light : Brightness.dark;

    final defaultStyle =
        (isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
            .copyWith(statusBarColor: Colors.transparent);

    final customStyle = defaultStyle.copyWith(
      statusBarIconBrightness: brightness,
      systemNavigationBarIconBrightness: brightness,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarColor: Colors.transparent,
    );

    if ((environment.sdkVersion ?? 0) > 28) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (environment.sdkVersion ?? 0) > 28 ? customStyle : defaultStyle,
      child: ValueListenableBuilder<Box>(
        valueListenable: Hive.box(BoxType.settings.name).listenable(
          keys: [oledModeKey, themeModeKey],
        ),
        builder: (context, value, child) {
          final bool isOled = value.get(oledModeKey, defaultValue: false);

          final ThemeMode themeMode = ThemeMode.values[value.get(
            themeModeKey,
            defaultValue: 0,
          )];

          return AppThemeBuilder(
            builder: (context, appTheme) => MaterialApp.router(
              //useInheritedMediaQuery: true,
              debugShowCheckedModeBanner: false,

              //showPerformanceOverlay: true,
              //checkerboardOffscreenLayers: true,
              //checkerboardRasterCacheImages: true,

              theme: appTheme.day,
              darkTheme: isOled ? appTheme.midnight : appTheme.night,
              title: appTitle,
              themeMode: themeMode,
              routerConfig: router,
              builder: (context, child) {
                if (!kDebugMode) {
                  ErrorWidget.builder = (FlutterErrorDetails error) {
                    return const Center(
                      child: Text('Произошла ошибка'),
                    );
                  };
                }

                /// fix high textScaleFactor
                final mediaQuery = MediaQuery.of(context);
                final scale =
                    mediaQuery.textScaleFactor.clamp(0.8, 1).toDouble();

                return MediaQuery(
                  data: mediaQuery.copyWith(textScaleFactor: scale),
                  child: child!,
                );
              },
            ),
          );
        },
      ),
    );

    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(BoxType.settings.name).listenable(
        keys: [oledModeKey, themeModeKey],
      ),
      builder: (context, value, child) {
        final bool isOled = value.get(oledModeKey, defaultValue: false);

        final ThemeMode themeMode = ThemeMode.values[value.get(
          themeModeKey,
          defaultValue: 0,
        )];

        return AppThemeBuilder(
          builder: (context, appTheme) => MaterialApp.router(
            //useInheritedMediaQuery: true,
            debugShowCheckedModeBanner: false,

            //showPerformanceOverlay: true,
            //checkerboardOffscreenLayers: true,
            //checkerboardRasterCacheImages: true,

            theme: appTheme.day,
            darkTheme: isOled ? appTheme.midnight : appTheme.night,
            title: appTitle,
            themeMode: themeMode,
            routerConfig: router,
            builder: (context, child) {
              if (!kDebugMode) {
                ErrorWidget.builder = (FlutterErrorDetails error) {
                  return const Center(
                    child: Text('Произошла ошибка'),
                  );
                };
              }

              /// fix high textScaleFactor
              final mediaQuery = MediaQuery.of(context);
              final scale = mediaQuery.textScaleFactor.clamp(0.8, 1).toDouble();

              return MediaQuery(
                data: mediaQuery.copyWith(textScaleFactor: scale),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}
