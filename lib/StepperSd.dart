import 'package:flutter/material.dart';

class MultiStepForm extends StatefulWidget {
  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: [
                _buildProgressIndicator(),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: _getStepContent(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepIndicator(0),
        _lineIndicator(),
        _stepIndicator(1),
        _lineIndicator(),
        _stepIndicator(2),
      ],
    );
  }

  Widget _stepIndicator(int step) {
    bool isActive = _currentStep == step;
    bool isCompleted = _currentStep > step;
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? Colors.red : (isActive ? Colors.red : Colors.grey.shade300),
      ),
      child: CircleAvatar(
        radius: 12,
        backgroundColor: isCompleted ? Colors.red : Colors.white,
        child: Text(
          (step + 1).toString(),
          style: TextStyle(color: isCompleted ? Colors.white : (isActive ? Colors.red : Colors.grey)),
        ),
      ),
    );
  }

  Widget _lineIndicator() {
    return Container(
      width: 30,
      height: 2,
      color: Colors.grey.shade300,
    );
  }

  Widget _getStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStepOne();
      case 1:
        return _buildStepTwo();
      case 2:
        return _buildStepThree();
      default:
        return _buildStepOne();
    }
  }

  Widget _buildStepOne() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: "Address1", border: OutlineInputBorder()),
          validator: (value) =>
          value?.isEmpty ?? true ? "Enter your address" : null,
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(labelText: "Address2", border: OutlineInputBorder()),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(labelText: "Address3", border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildStepTwo() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: "City", border: OutlineInputBorder()),
          validator: (value) => value?.isEmpty ?? true ? "Enter your city" : null,
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(labelText: "Pincode", border: OutlineInputBorder()),
          validator: (value) =>
          value?.isEmpty ?? true ? "Enter your pincode" : null,
        ),
      ],
    );
  }

  Widget _buildStepThree() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: "State Name", border: OutlineInputBorder()),
          validator: (value) =>
          value?.isEmpty ?? true ? "Enter your state" : null,
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(labelText: "Voter ID", border: OutlineInputBorder()),
          validator: (value) =>
          value?.isEmpty ?? true ? "Enter your voter ID" : null,
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep += 1;
            });
          } else if (_formKey.currentState?.validate() ?? false) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Form submitted successfully")),
            );
          }
        },
        child: Text(
          _currentStep == 2 ? "SUBMIT" : "NEXT",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
