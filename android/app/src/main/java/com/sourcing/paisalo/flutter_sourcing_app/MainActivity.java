package com.sourcing.paisalo.flutter_sourcing_app;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;
import android.content.Intent;
import java.util.List;
import java.math.BigInteger;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.Iterator;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import android.provider.MediaStore;
import androidx.activity.result.ActivityResultCallback;
import java.io.IOException;
import java.io.ByteArrayInputStream;
import java.util.LinkedList;

import android.util.Log;
import java.util.zip.GZIPInputStream;
import java.io.ByteArrayOutputStream;
import androidx.activity.result.ActivityResultLauncher;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
/*import com.sourcing.paisalo.flutter_sourcing_app.AadharData;
import com.sourcing.paisalo.flutter_sourcing_app.AadharUtils;*/
import io.flutter.plugin.common.MethodChannel;
import java.util.Collections;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
public class MainActivity extends FlutterFragmentActivity  {
    protected static final byte SEPARATOR_BYTE = (byte)255;
    public static final String TESTING_PACKAGE_NAME = "com.emudhra.esignpdf.sandbox"; // Testing Environment
    public static final String PRODUCTION_PACKAGE_NAME = "com.emudhra.esignpdf"; // Production Environment

    private static final String CHANNEL = "com.example.intent"; // Same channel name as in Flutter
    Result result_global;
    protected ArrayList<String> decodedData;
    private static final int APK_ESIGN_REQUEST_CODEP = 404;
    private static final int APK_ESIGN_REQUEST_CODEM = 405;
    protected static final int VTC_INDEX = 15;
    protected int emailMobilePresent, imageStartIndex, imageEndIndex;
    protected String signature,email,mobile;
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Create a MethodChannel to handle method calls from Flutter
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        result_global=result;
                        if (call.method.equals("callJavaFunctionP")) {
                            String xml =call.arguments();
                            // Call your Java method here and return a result
                            callJavaFunctionP(xml); // Example of calling your Java function
                            // Send result back to Flutter
                        }else if (call.method.equals("callJavaFunctionM")) {
                            String xml =call.arguments();
                            // Call your Java method here and return a result
                            callJavaFunctionM(xml); // Example of calling your Java function
                            // Send result back to Flutter
                        } else  if (call.method.equals("callJavaMethodQr")) {
                            openQRActivity();
                        } else {
                            result.notImplemented();
                        }
                    }
                });
    }
    private void openQRActivity() {
        IntentIntegrator scanIntegrator = new IntentIntegrator(this);
        scanIntegrator.setOrientationLocked(false);
        scanIntegrator.initiateScan(Collections.singleton("QR_CODE"));
    }
//protean
    // Example Java method
    private void callJavaFunctionP(String xml) {
        String responseUrl="https://predeptest.paisalo.in:8084/PDL.ESign.API/api/E_Sign/XMLReaponseNew";

        // Your Java logic here
        Intent appStartIntent = new Intent();
        appStartIntent.setAction("com.nsdl.egov.esign.rdservice.fp.CAPTURE");
        appStartIntent.putExtra("msg", xml); // msg contains esign request xml from ASP.
        appStartIntent.putExtra("env", "PROD"); //Possible values PREPROD or PROD (case insensative).
        appStartIntent.putExtra("returnUrl", responseUrl); // your package name where esign response failure/success will be sent.
        startActivityForResult(appStartIntent, APK_ESIGN_REQUEST_CODEP);
    }
//emudra
    private void callJavaFunctionM(String xml) {

        String responseUrl = "https://apiuat.paisalo.in:4015/PDLEmudra/api/ESign/HandleCallbackMobileresponse";
        try {
            Intent appStartIntent = new Intent();
            appStartIntent.setAction("com.emudhra.esignpdf.sign");
            appStartIntent.putExtra("txnRef", xml);
            startActivityForResult(appStartIntent, APK_ESIGN_REQUEST_CODEM);
        } catch (ActivityNotFoundException e) {
            redirectToPlayStoreForeMudhraApp(true);
        }
    }



    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Log.d("TAG", "onActivityResult: resultCode "+resultCode);
        Log.d("TAG", "onActivityResult: data "+data);
        Log.d("TAG", "onActivityResult: requestCode "+requestCode);
        //protean
          if (requestCode == APK_ESIGN_REQUEST_CODEP) {
            if (resultCode == RESULT_OK) {
                try {
                    String eSignResponse = data.getStringExtra("signedResponse");
                    result_global.success(eSignResponse);
                }catch (Exception e){
                    result_global.success(e.getMessage());
                }
            } else {
                result_global.success("Something went wrong during Esign Processing. Please contact administrator(NSDL)");
            }
        }

        //emudra
        if (requestCode == APK_ESIGN_REQUEST_CODEM) {
            if (data != null) {
              String  status =data.getStringExtra("status");
                String errorMsg = data.getStringExtra("errorMsg");
                String responseXML= data.getStringExtra("responseXML");
                try {
                    //String eSignResponse = data.getStringExtra("signedResponse");
                    result_global.success(responseXML);
                }catch (Exception e){
                    result_global.success(e.getMessage());
                }

            }



        } else
        if (requestCode == IntentIntegrator.REQUEST_CODE) {
            IntentResult scanningResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
            //Log.d("QR Scan","Executed");
            if (scanningResult != null) {
                //we have a result
                String scanContent = scanningResult.getContents();
                String scanFormat = scanningResult.getFormatName();
                if (scanFormat != null) {
                   setAadharContent(scanContent);
                  //  android.util.Log.d(TAG, "onActivityResult: "+scanContent);
                }

        }

    }
    }

    private void setAadharContent(String aadharDataString)  {

            final BigInteger bigIntScanData = new BigInteger(aadharDataString, 10);
            // 2. Convert BigInt to Byte Array
            final byte byteScanData[] = bigIntScanData.toByteArray();

            // 3. Decompress Byte Array
            final byte[] decompByteScanData = decompressData(byteScanData);

            // 4. Split the byte array using delimiter
            List<byte[]> parts = separateData(decompByteScanData);
            // Throw error if there are no parts
            decodeData(parts);
//            decodeSignature(decompByteScanData);
//            decodeMobileEmail(decompByteScanData);
          //  aadharNumberentry=true;



    }

    // 20/11/2022 ========================================
    protected byte[] decompressData(byte[] byteScanData) {
        ByteArrayOutputStream bos = new ByteArrayOutputStream(byteScanData.length);
        ByteArrayInputStream bin = new ByteArrayInputStream(byteScanData);
        GZIPInputStream gis = null;

        try {
            gis = new GZIPInputStream(bin);
        } catch (IOException e) {
            Log.e("Exception", "Decompressing QRcode, Opening byte stream failed: " + e.toString());
            // throw new QrCodeException("Error in opening Gzip byte stream while decompressing QRcode",e);
        }

        int size = 0;
        byte[] buf = new byte[1024];
        while (size >= 0) {
            try {
                size = gis.read(buf,0,buf.length);
                if(size > 0){
                    bos.write(buf,0,size);
                }
            } catch (IOException e) {
                Log.e("Exception", "Decompressing QRcode, writing byte stream failed: " + e.toString());
                // throw new QrCodeException("Error in writing byte stream while decompressing QRcode",e);
            }
        }

        try {
            gis.close();
            bin.close();
        } catch (IOException e) {
            Log.e("Exception", "Decompressing QRcode, closing byte stream failed: " + e.toString());
            // throw new QrCodeException("Error in closing byte stream while decompressing QRcode",e);
        }

        return bos.toByteArray();
    }

    protected List<byte[]> separateData(byte[] source) {
        List<byte[]> separatedParts = new LinkedList<>();
        int begin = 0;

        for (int i = 0; i < source.length; i++) {
            if(source[i] == SEPARATOR_BYTE){
                // skip if first or last byte is separator
                if(i != 0 && i != (source.length -1)){
                    separatedParts.add(Arrays.copyOfRange(source, begin, i));
                }
                begin = i + 1;
                // check if we have got all the parts of text data
                if(separatedParts.size() == (VTC_INDEX + 1)){
                    // this is required to extract image data
                    imageStartIndex = begin;
                    break;
                }
            }
        }
        return separatedParts;
    }
    public static String removeSpecialAndSingleChars(String input) {
        // Regular expression to match only alphanumeric characters
        String regex = "[^a-zA-Z0-9]";

        // Remove special characters
        String cleanedString = input.replaceAll(regex, "");

        // Remove single characters
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < cleanedString.length(); i++) {
            char currentChar = cleanedString.charAt(i);
            if (i == 0 || currentChar != cleanedString.charAt(i - 1)) {
                result.append(currentChar);
            }
        }

        return result.toString().trim();
    }
    protected void decodeSignature(byte[] decompressedData){
        // extract 256 bytes from the end of the byte array
        int startIndex = decompressedData.length - 257,
                noOfBytes = 256;
        try {
            signature = new String (decompressedData,startIndex,noOfBytes,"ISO-8859-1");
            Log.e("signature======>","signature===> "+signature);
        } catch (UnsupportedEncodingException e) {
            Log.e("Exception", "Decoding Signature of QRcode, ISO-8859-1 not supported: " + e.toString());
            // throw new QrCodeException("Decoding Signature of QRcode, ISO-8859-1 not supported",e);
        }

    }


    protected void decodeData(List<byte[]> encodedData) {
        try {
            Log.e("Parts======1======> ","part data =====> "+decodedData.toString());

            Iterator<byte[]> i = encodedData.iterator();
            decodedData = new ArrayList<String>();
            while(i.hasNext()){
                Log.e("Parts======4======> ","part data =====> "+decodedData.toString());

                decodedData.add(new String(i.next(), StandardCharsets.ISO_8859_1));
            }
            // set the value of email/mobile present flag
            Log.e("Parts======2======> ","part data =====> "+decodedData.toString());
            //emailMobilePresent = Integer.parseInt(decodedData[0]);

            result_global.success(decodedData.toString());
        }catch (Error e){
            Log.e("Parts======3======> ","part data =====> "+e);
        }



    }

    private String concatenateStrings(String[] strings, int startIndex, int endIndex) {
        StringBuilder result = new StringBuilder();
        for (int i = startIndex; i < endIndex; i++) {
            if (i > startIndex) {
                result.append(",");
            }
            result.append(strings[i]);
        }
        return result.toString();
    }

    private void appendIfNotNullOrEmpty(StringBuilder stringBuilder, String str) {
        if (str != null && !str.isEmpty()) {
            if (stringBuilder.length() > 0) {
                stringBuilder.append(",");
            }
            stringBuilder.append(str);
        }
    }

    protected void decodeMobileEmail(byte[] decompressedData){
        int mobileStartIndex = 0,mobileEndIndex = 0,emailStartIndex = 0,emailEndIndex = 0;
        switch (emailMobilePresent){
            case 3:
                // both email mobile present
                mobileStartIndex = decompressedData.length - 289; // length -1 -256 -32
                mobileEndIndex = decompressedData.length - 257; // length -1 -256
                emailStartIndex = decompressedData.length - 322;// length -1 -256 -32 -1 -32
                emailEndIndex = decompressedData.length - 290;// length -1 -256 -32 -1

                mobile = bytesToHex (Arrays.copyOfRange(decompressedData,mobileStartIndex,mobileEndIndex+1));
                email = bytesToHex (Arrays.copyOfRange(decompressedData,emailStartIndex,emailEndIndex+1));
                // set image end index, it will be used to extract image data
                imageEndIndex = decompressedData.length - 323;
                break;

            case 2:
                // only mobile
                email = "";
                mobileStartIndex = decompressedData.length - 289; // length -1 -256 -32
                mobileEndIndex = decompressedData.length - 257; // length -1 -256

                mobile = bytesToHex (Arrays.copyOfRange(decompressedData,mobileStartIndex,mobileEndIndex+1));
                // set image end index, it will be used to extract image data
                imageEndIndex = decompressedData.length - 290;

                break;

            case 1:
                // only email
                mobile = "";
                emailStartIndex = decompressedData.length - 289; // length -1 -256 -32
                emailEndIndex = decompressedData.length - 257; // length -1 -256

                email = bytesToHex (Arrays.copyOfRange(decompressedData,emailStartIndex,emailEndIndex+1));
                // set image end index, it will be used to extract image data
                imageEndIndex = decompressedData.length - 290;
                break;

            default:
                // no mobile or email
                mobile = "";
                email = "";
                // set image end index, it will be used to extract image data
                imageEndIndex = decompressedData.length - 257;
        }

        Log.e("email mobile======> ","Data=====>"+email +"   "+mobile);

    }

    public static String bytesToHex(byte[] bytes) {
        final char[] hexArray = "0123456789ABCDEF".toCharArray();

        char[] hexChars = new char[bytes.length * 2];
        for ( int j = 0; j < bytes.length; j++ ) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }


    //=================================================
    private void redirectToPlayStoreForeMudhraApp(boolean isProduction) {
        String emudhraAppPackageName = isProduction ? PRODUCTION_PACKAGE_NAME : TESTING_PACKAGE_NAME;

        try {
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + emudhraAppPackageName)));
        } catch (ActivityNotFoundException ex) {
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + emudhraAppPackageName)));
        }
    }

}
