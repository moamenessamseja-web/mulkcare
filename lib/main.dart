import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/i18n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/store/app_store.dart';

void main() {
  runApp(const MulkCareApp());
}

class MulkCareApp extends StatelessWidget {
  const MulkCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStore()..init(),
      child: Consumer<AppStore>(
        builder: (context, store, _) {
          return MaterialApp.router(
            title: 'MulkCare',
            debugShowCheckedModeBanner: false,
            locale: store.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: buildRouter(store),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1783FF),
                brightness: Brightness.light,
              ),
              fontFamily: 'Tajawal',
            ),
          );
        },
      ),
    );
  }
}
