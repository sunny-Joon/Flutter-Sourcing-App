package com.sourcing.paisalo.flutter_sourcing_app;

import android.content.Intent;
import android.provider.MediaStore;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.example.intent"; // Same channel name as in Flutter
    Result result_global;
    private static final int APK_ESIGN_REQUEST_CODE = 404;
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Create a MethodChannel to handle method calls from Flutter
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        result_global=result;
                        if (call.method.equals("callJavaFunction")) {
                            String xml =call.arguments();


                            // Call your Java method here and return a result
                            callJavaFunction(xml); // Example of calling your Java function
                           // Send result back to Flutter
                        } else {
                            result.notImplemented(); // If method is not implemented
                        }
                    }
                });
    }

    // Example Java method
    private void callJavaFunction(String xml) {
        String responseUrl="https://predeptest.paisalo.in:8084/PDL.ESign.API/api/E_Sign/XMLReaponseNew";

        // Your Java logic here

        Intent appStartIntent = new Intent();
        appStartIntent.setAction("com.nsdl.egov.esign.rdservice.fp.CAPTURE");
        appStartIntent.putExtra("msg", xml); // msg contains esign request xml from ASP.
        appStartIntent.putExtra("env", "PROD"); //Possible values PREPROD or PROD (case insensative).
        appStartIntent.putExtra("returnUrl", responseUrl); // your package name where esign response failure/success will be sent.
        startActivityForResult(appStartIntent, APK_ESIGN_REQUEST_CODE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == APK_ESIGN_REQUEST_CODE) {
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
    }

}
