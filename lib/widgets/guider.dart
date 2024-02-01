import 'package:flutter/material.dart';
import 'package:flutter_test_project/generated/l10n.dart';
import 'package:flutter_test_project/widgets/typography.dart';

class UsageGuideBottomSheet extends StatefulWidget {
  const UsageGuideBottomSheet({Key? key}) : super(key: key);

  @override
  _UsageGuideBottomSheetState createState() => _UsageGuideBottomSheetState();
}

class _UsageGuideBottomSheetState extends State<UsageGuideBottomSheet> {
  int _currentStep = 0;

  List<Step> steps = [
    Step(
      title: Text(
        "${S.current.step} 1",
        style: Style.bodyBold,
      ),
      content: Text(S.current.step1, style: Style.bodyRegular),
    ),
    Step(
      title: Text(
        "${S.current.step} 2",
        style: Style.bodyBold,
      ),
      content: Text(S.current.step2, style: Style.bodyRegular),
    ),
    Step(
      title: Text(
        "${S.current.step} 3",
        style: Style.bodyBold,
      ),
      content: Text(S.current.step3, style: Style.bodyRegular),
    ),
    Step(
      title: Text(
        "${S.current.step} 4",
        style: Style.bodyBold,
      ),
      content: Text(S.current.step4, style: Style.bodyRegular),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Stepper(
            currentStep: _currentStep,
            steps: steps,
            onStepContinue: () {
              setState(() {
                if (_currentStep < steps.length - 1) {
                  _currentStep += 1;
                }
              });
            },
            onStepCancel: () {
              setState(() {
                if (_currentStep > 0) {
                  _currentStep -= 1;
                }
              });
            },
          ),
        );
      },
    );
  }
}
