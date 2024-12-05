import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'qr_scan_page.dart';

class QRDATA extends StatefulWidget {
  const QRDATA({super.key, required this.title});



  final String title;

  @override
  State<QRDATA> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<QRDATA> {
  int _counter = 0;
  int imageStartIndex = 0;
  String qrResult = 'No QR Code scanned yet.';
  Future<void> _incrementCounter() async {

    // openAnotherAppWithData();
    // Navigate to QR Scanner screen and wait for result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRViewExample()),
    );

    // If result is not null, update the state
    if (result != null) {

      BigInt bigIntScanData = BigInt.parse(result);
      List<int> byteScanData = bigIntToBytes(bigIntScanData);

      List<int> decompByteScanData = decompressData(byteScanData);
      List<List<int>>  parts =separateData(decompByteScanData, 255, 15);

      setState(() {

        qrResult= decodeData(parts);
      });
    }

  }

  List<int> bigIntToBytes(BigInt bigInt) {
    // Convert BigInt to a byte array (List<int>)
    List<int> byteArray = [];
    while (bigInt > BigInt.zero) {
      byteArray.add((bigInt & BigInt.from(0xFF)).toInt());
      bigInt = bigInt >> 8; // Shift right by 8 bits
    }
    return byteArray.reversed.toList(); // Reverse to maintain byte order
  }

  List<int> decompressData(List<int> byteScanData) {
    try {
      // Decompress the GZIP data
      List<int> decompressedData = GZipDecoder().decodeBytes(byteScanData);

      return decompressedData; // Return decompressed data as List<int>
    } catch (e) {
      print('Exception: Decompressing QRcode failed: $e');
      // Handle error appropriately (e.g., throw a custom exception)
      return []; // Returning an empty List<int> on error
    }
  }

  List<List<int>> separateData(List<int> source, int separatorByte, int vtcIndex) {
    List<List<int>> separatedParts = [];
    int begin = 0;

    for (int i = 0; i < source.length; i++) {
      if (source[i] == separatorByte) {
        // Skip if first or last byte is a separator
        if (i != 0 && i != (source.length - 1)) {
          // Copy the range from 'begin' to 'i' (exclusive)
          separatedParts.add(source.sublist(begin, i));
        }
        begin = i + 1;

        // Check if we have got all the parts of text data
        if (separatedParts.length == (vtcIndex + 1)) {
          // This is required to extract image data
          // Assuming imageStartIndex is a global variable
          imageStartIndex = begin;
          break;
        }
      }
    }
    return separatedParts;
  }

  String decodeData(List<List<int>> encodedData) {
    String test="";
    List<String> decodedData = [];

    for (var byteArray in encodedData) {
      // Decode using ISO-8859-1
      String decodedString = utf8.decode(byteArray); // Change to ISO-8859-1 if necessary
      decodedData.add(decodedString);

      test+=decodedString;




    }

    return test;
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: SingleChildScrollView(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              '$qrResult',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



  /*void openAnotherAppWithData() async {
    String xml="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?><Esign AuthMode=\"1\" aspId=\"ASPSEILPROD010\" ekycId=\"\" ekycIdType=\"A\" responseSigType=\"pkcs7pdf\" responseUrl=\"https://predeptest.paisalo.in:8084/PDL.ESign.API/api/ESignCheckCallBackUrl/XMLReaponseNew\" sc=\"Y\" ts=\"2024-09-20T12:28:31\" txn=\"UKC:eSign:4097:20240920122824678\" ver=\"2.1\"><Docs><InputHash docInfo=\"Document for eSign\" hashAlgorithm=\"SHA256\" id=\"1\">5765767aeb71c5145b2d0cb4616d2289afc8742d7036adf7925e301366e4b10f</InputHash></Docs><Signature xmlns=\"http://www.w3.org/2000/09/xmldsig#\"><SignedInfo><CanonicalizationMethod Algorithm=\"http://www.w3.org/TR/2001/REC-xml-c14n-20010315\"/><SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"/><Reference URI=\"\"><Transforms><Transform Algorithm=\"http://www.w3.org/2000/09/xmldsig#enveloped-signature\"/></Transforms><DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"/><DigestValue>5R3AxoC30/NlLOalX7PvAWpPmVg=</DigestValue></Reference></SignedInfo><SignatureValue>fp6/Caqjcp6yTQ1qssWQeYEKA99kinalMl0JbYUofwilnLCyMzny/sLdIslnMnbzwZnk0xoudWrB&#13;\n" +
        "vLgz557eWKOLpbyu+mrPSkCHd9Bj9aewmbMAc1eV5RDLSD0CyG6e3n9GT1XX7UEv++c2jSgBcfmA&#13;\n" +
        "biqsLTIIeUEJPzaY2+WFo/4apsMzlHX7Gyv6BYxTlDbabHRqOJdb+RchIhfJiSslvKBdiUua2zTb&#13;\n" +
        "1KhOe04m+f4lUe4hWskNtY87Janti5J1BiXCKmQiKHA/QeRq5rs+yWFqdYKe+vQbZkaK9CQCBt9Z&#13;\n" +
        "Ik7/9rFKA1RFxk+m96Y8SWBPreS5wmCUxrEdeg==</SignatureValue><KeyInfo><X509Data><X509SubjectName>CN=DS PAISALO DIGITAL LIMITED 1,2.5.4.5=#134030414330384143434335334436443532414441413438343243314138313638423631423533433842463632344439413637394135444232413335303246313444,ST=Uttar Pradesh,2.5.4.17=#1306323832303032,OU='NA',O=PAISALO DIGITAL LIMITED,C=IN</X509SubjectName><X509Certificate>MIIFczCCBFugAwIBAgIGZD/oXd0HMA0GCSqGSIb3DQEBCwUAMHcxCzAJBgNVBAYTAklOMSIwIAYD&#13;\n" +
        "VQQKExlTaWZ5IFRlY2hub2xvZ2llcyBMaW1pdGVkMQ8wDQYDVQQLEwZTdWItQ0ExMzAxBgNVBAMT&#13;\n" +
        "KlNhZmVTY3J5cHQgc3ViLUNBIGZvciBEb2N1bWVudCBTaWduZXIgMjAyMjAeFw0yMjEyMTUxMTA0&#13;\n" +
        "MTZaFw0yNTEyMTUxMTA0MTZaMIHZMQswCQYDVQQGEwJJTjEgMB4GA1UEChMXUEFJU0FMTyBESUdJ&#13;\n" +
        "VEFMIExJTUlURUQxDTALBgNVBAsTBCdOQScxDzANBgNVBBETBjI4MjAwMjEWMBQGA1UECBMNVXR0&#13;\n" +
        "YXIgUHJhZGVzaDFJMEcGA1UEBRNAMEFDMDhBQ0NDNTNENkQ1MkFEQUE0ODQyQzFBODE2OEI2MUI1&#13;\n" +
        "M0M4QkY2MjREOUE2NzlBNURCMkEzNTAyRjE0RDElMCMGA1UEAxMcRFMgUEFJU0FMTyBESUdJVEFM&#13;\n" +
        "IExJTUlURUQgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALre7ZPBVBRe4JA04IsQ&#13;\n" +
        "F0VdCpr6BBCNqyWCNvTlrMCyZd/9aWev8qVIpTtdHyM2k+hbTKNYmNh7aC97nJHZ+Y6T9K9d6lkr&#13;\n" +
        "xzZvvXR/6CSBwqPqtC1O8SD3rJ8dN3gUuhBL9xEAPQvbQkMHoYhnBVWIghszH/1xf3d7kQMpCMOv&#13;\n" +
        "kE4rVtXS15LdWBp5K5DxCn7WTZfubPSwOR4DA8QgtkWdg02O32n6NA+J1jDEr1cidggPh8fjti8M&#13;\n" +
        "IpyPxyIyA1DH3OCwDtfs9gMypsqDoiJtvJvf7ikwRs/6X4OLHjUimLTIof5G/AQet/GMIoPNEg/W&#13;\n" +
        "fX9LzxLPcMwEGUMbrOUCAwEAAaOCAaAwggGcMBMGA1UdIwQMMAqACEzEC7kvPc60MBEGA1UdDgQK&#13;\n" +
        "BAhIfbM2loUA+DCBlwYIKwYBBQUHAQEEgYowgYcwRQYIKwYBBQUHMAKGOWh0dHBzOi8vd3d3LnNh&#13;\n" +
        "ZmVzY3J5cHRuZXcuY29tL1NhZmVTY3J5cHREb2NTaWduZXIyMDIyLmNlcjA+BggrBgEFBQcwAYYy&#13;\n" +
        "aHR0cDovL29jc3Auc2FmZXNjcnlwdC5jb20vU2FmZVNjcnlwdERvY1NpZ25lcjIwMjIwRwYDVR0f&#13;\n" +
        "BEAwPjA8oDqgOIY2aHR0cDovL2NybDIuc2FmZXNjcnlwdC5jb20vU2FmZVNjcnlwdERvY1NpZ25l&#13;\n" +
        "cjIwMjIuY3JsMCcGA1UdIAQgMB4wCAYGYIJkZAIDMAgGBmCCZGQCAjAIBgZggmRkCgEwDAYDVR0T&#13;\n" +
        "AQH/BAIwADAqBgNVHSUEIzAhBggrBgEFBQcDBAYJKoZIhvcvAQEFBgorBgEEAYI3CgMMMBwGA1Ud&#13;\n" +
        "EQQVMBOBEUhhcmlzaEBwYWlzYWxvLmluMA4GA1UdDwEB/wQEAwIGwDANBgkqhkiG9w0BAQsFAAOC&#13;\n" +
        "AQEAp0fMpXmD5y47GsoKyR0H/w/rNTpU46aJjYlpnrWmUhfnhK1Pfa3jxTPdXWxCE7xHAzmXqn5O&#13;\n" +
        "Ch+VGwi6enDUGfbN/u9U2PjRVGPwGh6aVZ6H46O3Usufe9MqR0JcTYNcv4M27XzyfE4h2GVX/MEc&#13;\n" +
        "Y4pJIaNKgBcKAHl80r7XFsbkuvU7qF5tL1IW5z27WEMAFkmEdnm/s+HTUDnfzBHx+mhADFFr96Gi&#13;\n" +
        "TZZh3uRn1J3H70okCqeq2rc3n12Fa8dA6iRlJV3tu15gPucWpAr4aAVX1o+4xYfhE3JRlell9GJH&#13;\n" +
        "PUmd6hcBwklYC2x4HMe+nnTxOHp7l2p8m/5M+6PJDg==</X509Certificate></X509Data></KeyInfo></Signature></Esign>\n";
    final intent = AndroidIntent(
      action: 'com.nsdl.egov.esign.rdservice.fp.CAPTURE',
      arguments: <String, dynamic>{
        'msg': xml,
        'env': 'PROD',
        'returnUrl': 'https://erpservice.paisalo.in:980/EsignTest/api/DocSignIn/XMLReaponse',
      },
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    await intent.launch();
  }*/
}