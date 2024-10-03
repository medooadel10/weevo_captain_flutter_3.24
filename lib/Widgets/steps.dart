import 'package:flutter/material.dart';

class Steps extends StatefulWidget {
  const Steps({super.key});

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stepper(
          currentStep: _currentStep,
          physics: const ScrollPhysics(),
          type: StepperType.horizontal,
          onStepContinue: () {
            setState(() {
              _currentStep++;
            });
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            }
          },
          onStepTapped: (int i) {
            setState(() => _currentStep = i);
          },
          steps: [
            Step(
              title: const Text('Step 1'),
              content: const Text('content'),
              isActive: _currentStep == 0 ? true : false,
              state: StepState.complete,
            ),
            Step(
              title: const Text('Step 2'),
              content: const Text('content'),
              isActive: _currentStep == 1 ? true : false,
            ),
            Step(
              title: const Text('Step 3'),
              content: const Text('content'),
              isActive: _currentStep == 2 ? true : false,
            ),
          ]),
    );
  }
}
