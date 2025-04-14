import 'package:flutter/material.dart';

class SecondEsign extends StatelessWidget {
  const SecondEsign({Key? key}) : super(key: key);

  Widget buildCard({
    required String name,
    required String fatherName,
    required String esignAs,
    required String mobile,
    required String creator,
    required String deviceId,
    required String address,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name with icon
          Row(
            children: [
              const Icon(Icons.account_circle, color: Colors.white, size: 70),
              const SizedBox(width: 6),
              Text(
                name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          buildRow("Father/Spouse", fatherName),
          buildRow("eSign As", esignAs),
          buildRow("Mobile", mobile),
          buildRow("Creater", creator),
          buildRow("Device Id", deviceId),
          buildRow("Address", address),
        ],
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "$title:",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD42D3F),
      body: SafeArea(

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
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
                          child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Center(
                      child: Image.asset(
                        'assets/Images/logo_white.png', // Replace with your logo asset path
                        height: 40,
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFD42D3F),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "DOWNLOAD DOCUMENT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              buildCard(
                name: "Anuruddha Vashishtha",
                fatherName: "Munna Lal Sharma",
                esignAs: "Borrower",
                mobile: "9557118608",
                creator: "HOAGRA",
                deviceId: "HOAGRA",
                address: "VILL- BAGDA POST- BAROLI\nAHIR, Agra, Agra",
              ),
              buildCard(
                name: "Raghvendra Pratap Singh",
                fatherName: "Jitendra Pratap Singh",
                esignAs: "Guarantor",
                mobile: "3698369639",
                creator: "HOAGRA",
                deviceId: "HOAGRA",
                address: "—",
              ),
            ],
          ),
        ),

      ),
    );
  }
}
