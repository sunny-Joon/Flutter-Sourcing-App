import 'package:flutter/material.dart';

class StepperSS extends StatefulWidget {
  @override
  _StepperSSState createState() => _StepperSSState();
}

class _StepperSSState extends State<StepperSS> {
  int _currentStep = 0;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      // Submit final form or take action on final step
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stepper Example'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Stepper Example',
                style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.red, // Background color for the stepper
              ),
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: _currentStep,
                onStepContinue: _nextStep,
                onStepCancel: _previousStep,
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: const Text('NEXT'),
                      ),
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('BACK'),
                      ),
                    ],
                  );
                },
                steps: <Step>[
                  Step(
                    title: Container(
                      color: Colors.red,
                      child: Text('Step 1', style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.white)),
                    ),
                    content: Form(
                      key: _formKey1,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: Container(
                      color: Colors.red,
                      child: Text('Step 2', style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.white)),
                    ),
                    content: Form(
                      key: _formKey2,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Address'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Phone Number'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                    title: Container(
                      color: Colors.red,
                      child: Text('Step 3', style: TextStyle(fontFamily: "Poppins-Regular",color: Colors.white)),
                    ),
                    content: Form(
                      key: _formKey3,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Username'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 2,
                    state: _currentStep == 2 ? StepState.indexed : StepState.complete,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
