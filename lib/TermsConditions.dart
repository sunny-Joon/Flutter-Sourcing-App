import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TermsConditions extends StatelessWidget {
  // The terms and conditions string
  final String termsText = """
  <b><u>TERMS & CONDITIONS FOR ONLINE PAYMENTS TO BE MADE TO PAISALO DIGITAL LTD</u></b><br>
  Name of NBFC:. <b>PAISALO DIGITAL LTD</b><br>
  CSC POCKET 52 CR PARK NEAR POLICE STATION<br>
  NEW DELHI -110019<br>
  WWW.PAISALO.IN<br><br>
  <b>Online Charges Payments</b>:<br>
  This online payment system is provided by PAISALO DIGITAL LTD. The PAISALO DIGITAL LTD may update these terms from time to time and any changes will be effective immediately on being set out on this portal. Please ensure that you are aware of the current terms. The country of domicile of PAISALO DIGITAL LTD is India and legal jurisdiction is New Delhi, India.<br>
  Please read these terms carefully before using the online payment facility. Using the Online payment facility on this website indicates that you accept these terms. If you do not accept these terms do not use this facility.<br><br>
  All payments are subject to the following conditions:<br>
   * The description of items is specific to you when you log in with your user id and unique password.<br>
   * All Charges quoted are in Indian Rupees.<br>
   * PAISALO DIGITAL LTD reserves the right to change the Charges at any time.<br>
   * Your payment to PAISALO DIGITAL LTD will normally reach PAISALO DIGITAL LTD account, within two working days.<br>
   * We cannot accept liability for a payment not reaching the correct account of PAISALO DIGITAL LTD, due to quoting an incorrect account number or incorrect details, by you. Neither can we accept liability if payment is refused or declined by the Net banking/credit/debit card supplier for any reason.<br>
   * If the Banker/card supplier declines payment, PAISALO DIGITAL LTD is under no obligation to bring this fact to your attention.<br>
   * It is for you (the Customer) to check with your bank/credit/debit card supplier that payment has been deducted from your account.<br>
   * In no event, PAISALO DIGITAL LTD will be liable for any damages whatsoever arising out of the use, computer virus, malware, inability to use, or the results of use of this site or any websites linked to this site, or the materials or information contained at any or all such sites, whether based on warranty, contract, tort or any other legal theory and whether or not advised of the possibility of such damages.<br><br>
  <b>Refund Policy :</b><br>
  Refunds, if applicable, at the discretion of the Management, will only be made as per the sources of Net Banking/debit/credit card used for the original transaction. For the avoidance of doubt, nothing in this Policy shall require PAISALO DIGITAL LTD to refund the Charges (or part thereof) unless such Charges (or part thereof) have previously been paid by the customer through online payment mode and the same has been credited into the accounts of PAISALO DIGITAL LTD and has the approval of the Management for refund. The Refunded amount will be credited back to source account within 7 working days.<br><br>
  <b>Cancel and Return Policy :</b><br>
  Cancel and Return, if applicable, at the discretion of the Management, will only be made as per the sources of Net Banking/debit/credit card used for the original transaction. For the avoidance of doubt, nothing in this Policy shall require PAISALO DIGITAL LTD to Cancel and Return the Charges (or part thereof) unless such Charges (or part thereof) have previously been paid by the customer through online payment mode and the same has been credited into the accounts of PAISALO DIGITAL LTD and has the approval of the Management for Cancel and Return. The cancellation and return will take up to 20 working days.<br>
  Privacy Policy<br>
  This Privacy Policy applies to all of the Fees, Payment of Dues, Charges and related payments payable to PAISALO DIGITAL LTD through online mode. Sometimes, we may post specific privacy notices to explain in more detail. If you have any questions about this Privacy Policy, please feel free to contact us through our email DELHI@PAISALO.IN<br>
  Changes to our Privacy Policy<br>
  PAISALO DIGITAL LTD reserves the entire right to modify / amend / remove this privacy statement anytime and without any reason. Nothing contained herein creates or is intended to create a contract/agreement between PAISALO DIGITAL LTD and any user visiting the website or providing Identifying information of any kind.<br><br>
  <b>DND Policy:</b><br>
  If you wish to stop any further sms/email alerts/contacts from our side, all you need to do is to send an email to DELHI@PAISALO.IN with your registered mobile number and you will be excluded from the ‘alerts list’.<br>
  Contact Email <i>DELHI@PAISALO.IN</i><br><br>
  <b>Terms of Payment:</b><br>
  1. Charges, Taxes applicable for online payment through Payment Gateway will be borne by the customer.<br>
  2. In respect of any failed transactions of any of the Customers, processed through this service, the amount will be refunded after deducting the transaction charges.<br>
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Conditions'),
        backgroundColor: Color(0xFFD42D3F), // Custom color for the AppBar
      ),
      body: Container(
        color: Color(0xFFD42D3F), // Set the background color
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: HtmlWidget(
            termsText,
            textStyle: TextStyle(
              fontSize: 16,
              color: Colors.white, // Set the text color to white
            ),
          ),
        ),
      ),
    );
  }
}
