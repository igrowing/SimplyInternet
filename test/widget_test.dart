import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/pages/home_page.dart';

import 'fakes.dart';

void main() {
  testWidgets('home screen shows the prompt and the single big button', (
    tester,
  ) async {
    final controller = DiagnosisController(
      runDiagnosis: RunDiagnosis(FakeNetworkProbe()),
      deviceActions: FakeDeviceActions(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<DiagnosisController>.value(
          value: controller,
          child: const HomePage(),
        ),
      ),
    );

    expect(find.textContaining('Internet does not work?'), findsOneWidget);
    expect(find.text('Find the problem and give solution'), findsOneWidget);
  });
}
