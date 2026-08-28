import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/core/theme/theme_controller.dart';
import 'package:simply_internet/features/diagnostics/data/datasources/platform_actions_datasource.dart';
import 'package:simply_internet/features/diagnostics/data/repositories/device_actions_impl.dart';
import 'package:simply_internet/features/diagnostics/data/repositories/network_probe_impl.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/device_actions.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/network_probe.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/settings/presentation/controllers/settings_controller.dart';
import 'package:simply_internet/features/urlcheck/data/repositories/url_history_impl.dart';
import 'package:simply_internet/features/urlcheck/data/repositories/url_inspector_impl.dart';
import 'package:simply_internet/features/urlcheck/domain/repositories/url_history.dart';
import 'package:simply_internet/features/urlcheck/domain/repositories/url_inspector.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';

/// Global service locator. Long-lived services are registered here rather than
/// being instantiated inline (see AGENTS.md).
final GetIt sl = GetIt.instance;

/// Wire up the dependency graph. Call once during app start-up.
void configureDependencies(SharedPreferences prefs) {
  sl
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerLazySingleton(() => ThemeController(sl<SharedPreferences>()))
    ..registerLazySingleton(PlatformActionsDatasource.new)
    ..registerLazySingleton<NetworkProbe>(NetworkProbeImpl.new)
    ..registerLazySingleton<DeviceActions>(
      () => DeviceActionsImpl(sl<PlatformActionsDatasource>()),
    )
    ..registerLazySingleton(
      () => SettingsController(
        prefs: sl<SharedPreferences>(),
        deviceActions: sl<DeviceActions>(),
      ),
    )
    ..registerLazySingleton(() => RunDiagnosis(sl<NetworkProbe>()))
    ..registerLazySingleton<UrlInspector>(UrlInspectorImpl.new)
    ..registerLazySingleton<UrlHistory>(
      () => UrlHistoryImpl(sl<SharedPreferences>()),
    )
    ..registerLazySingleton(() => CheckUrl(sl<UrlInspector>()))
    ..registerFactory(
      () => DiagnosisController(
        runDiagnosis: sl<RunDiagnosis>(),
        deviceActions: sl<DeviceActions>(),
      ),
    )
    ..registerFactory(
      () => UrlCheckController(
        checkUrl: sl<CheckUrl>(),
        deviceActions: sl<DeviceActions>(),
        networkProbe: sl<NetworkProbe>(),
        urlHistory: sl<UrlHistory>(),
      ),
    );
}
