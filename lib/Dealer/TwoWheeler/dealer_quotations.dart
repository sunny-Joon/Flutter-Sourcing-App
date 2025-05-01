import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VehicleQuotations extends StatefulWidget {
  const VehicleQuotations({super.key});

  @override
  State<VehicleQuotations> createState() => _VehicleQuotationsState();
}

class _VehicleQuotationsState extends State<VehicleQuotations> {
  TextEditingController mspController = TextEditingController();
  TextEditingController exShowroomPriceController = TextEditingController();
  TextEditingController rtoPriceController = TextEditingController();
  TextEditingController insurancePriceController = TextEditingController();
  TextEditingController PDDController = TextEditingController();
  TextEditingController DSASubventionController = TextEditingController();
  TextEditingController dealerSubventionController = TextEditingController();
  TextEditingController cppController = TextEditingController();
  TextEditingController processingFeeController = TextEditingController();
  TextEditingController stampDutyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFD42D3F),
        body: Column(children: [
          SizedBox(height: 42,),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: Center(
                      child: Icon(Icons.arrow_back_ios_sharp, size: 13),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Center(
                  child: Image.asset(
                    'assets/Images/logo_white.png',
                    // Replace with your logo asset path
                    height: 30,
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: _buildTextField2('On Road Price', mspController,
                          TextInputType.number, 7),
                    ),
                    Flexible(
                      child: _buildTextField2('Ex-Showroom Price',
                          exShowroomPriceController, TextInputType.number, 7),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: _buildTextField2('RTO Charges', rtoPriceController,
                          TextInputType.number, 7),
                    ),
                    Flexible(
                      child: _buildTextField2('Insurance Price',
                          insurancePriceController, TextInputType.number, 7),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: _buildTextField2('PDD Charges', PDDController,
                          TextInputType.number, 7),
                    ),
                    Flexible(
                      child: _buildTextField2('DSA Subvention',
                          DSASubventionController, TextInputType.number, 7),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: _buildTextField2('Dealer Subvention',
                          dealerSubventionController, TextInputType.number, 7),
                    ),
                    Flexible(
                      child: _buildTextField2('Processing Fee',
                          processingFeeController, TextInputType.number, 7),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: _buildTextField2('CPP Premium', cppController,
                          TextInputType.number, 7),
                    ),
                    Flexible(
                      child: _buildTextField2('Stamp Duty', stampDutyController,
                          TextInputType.number, 7),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.redAccent, Color(0xFFD42D3F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ))
        ]));
  }

  Widget _buildTextField2(String label, TextEditingController controller,
      TextInputType inputType, int maxlength) {
    return Container(
      color: Color(0xFFD42D3F),
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontFamily: "Poppins-Regular",
                fontSize: 13,
                color: Colors.white),
          ),
          SizedBox(height: 1),
          Container(
            width: double.infinity, // Set the desired width
            child: Center(
              child: TextFormField(
                maxLength: maxlength,
                style: TextStyle(color: Colors.white),
                controller: controller,
                keyboardType: inputType, // Set the input type
                decoration: InputDecoration(
                    border: OutlineInputBorder(), counterText: ""),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      '[a-zA-Z0-9]')), // Allow only alphanumeric characters // Optional: to deny spaces
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) => TextEditingValue(
                      text: newValue.text.toUpperCase(),
                      selection: newValue.selection,
                    ),
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
