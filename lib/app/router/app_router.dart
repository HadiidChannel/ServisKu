import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/maintenance/presentation/maintenance_form_screen.dart';
import '../../features/maintenance/presentation/maintenance_schedule_screen.dart';
import '../../features/motorcycles/presentation/add_edit_motorcycle_screen.dart';
import '../../features/motorcycles/presentation/motorcycle_detail_screen.dart';
import '../../features/motorcycles/presentation/motorcycle_list_screen.dart';
import '../../features/odometer/presentation/odometer_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/reports/presentation/expense_report_screen.dart';
import '../../features/service_records/presentation/service_history_screen.dart';
import '../../features/service_records/presentation/service_record_detail_screen.dart';
import '../../features/service_records/presentation/service_record_form_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../widgets/main_scaffold.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteNames.addMotorcycle,
      builder: (context, state) => const AddEditMotorcycleScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.home,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.vehicles,
              builder: (context, state) => const MotorcycleListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.history,
              builder: (context, state) => const ServiceHistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.reports,
              builder: (context, state) => const ExpenseReportScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.vehicleDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MotorcycleDetailScreen(motorcycleId: id);
      },
    ),
    GoRoute(
      path: RouteNames.vehicleOdometer,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return OdometerScreen(motorcycleId: id);
      },
    ),
    GoRoute(
      path: RouteNames.vehicleMaintenance,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MaintenanceScheduleScreen(motorcycleId: id);
      },
    ),
    GoRoute(
      path: RouteNames.addMaintenance,
      builder: (context, state) {
        final vehicleId = state.uri.queryParameters['vehicleId'];
        return MaintenanceFormScreen(vehicleId: vehicleId);
      },
    ),
    GoRoute(
      path: RouteNames.editMaintenance,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MaintenanceFormScreen(scheduleId: id);
      },
    ),
    GoRoute(
      path: RouteNames.addServiceRecord,
      builder: (context, state) {
        final vehicleId = state.uri.queryParameters['vehicleId'];
        return ServiceRecordFormScreen(vehicleId: vehicleId);
      },
    ),
    GoRoute(
      path: RouteNames.editServiceRecord,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ServiceRecordFormScreen(recordId: id);
      },
    ),
    GoRoute(
      path: RouteNames.serviceRecordDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ServiceRecordDetailScreen(recordId: id);
      },
    ),
    GoRoute(
      path: RouteNames.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
