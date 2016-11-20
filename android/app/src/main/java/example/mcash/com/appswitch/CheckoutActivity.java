package example.mcash.com.appswitch;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;

public class CheckoutActivity extends AppCompatActivity {
    public static String LOG_TAG = CheckoutActivity.class.getSimpleName();
    private String tid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_checkout);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        findViewById(R.id.checkout_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showSpinner(true);
                Toast.makeText(CheckoutActivity.this, "Creating payment request...",
                               Toast.LENGTH_LONG).show();
                PaymentApi.getInstance().createPaymentRequest(new PaymentRequestCallback());
            }
        });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 1337)
            handleAppSwitchResult(resultCode, data);
        else
            super.onActivityResult(requestCode, resultCode, data);
    }

    private void handleAppSwitchResult(int resultCode, Intent data) {
        int MCASH_RES_OK = -1;
        if (resultCode == MCASH_RES_OK)
            Toast.makeText(this, "AppSwitch successful. Fetching payment status...",
                           Toast.LENGTH_LONG).show();
        else
            Toast.makeText(this, "AppSwitch error", Toast.LENGTH_LONG).show();

        PaymentApi.getInstance().getPaymentStatus(new PaymentStatusCallback(), tid);
    }

    private void handleResponseError(String message) {
        Log.e(LOG_TAG, message);
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }

    private void showSpinner(final boolean show) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                int visibility = show ? View.VISIBLE : View.GONE;
                findViewById(R.id.spinner).setVisibility(visibility);
            }
        });

    }

    private class PaymentRequestCallback implements Callback {
        @Override
        public void onFailure(Call call, IOException e) {
            handleResponseError(String.format("Checkout error due to <%s>", e.getMessage()));
        }

        @Override
        public void onResponse(Call call, Response response) throws IOException {
            if (response.isSuccessful()) {
                try {
                    JSONObject json = new JSONObject(response.body().string());
                    tid = json.getString("id");
                    Intent intent = new Intent(
                            Intent.ACTION_VIEW,
                            Uri.parse("mcash://qr?code=http://mca.sh/p/" + tid + "/")
                    );
                    startActivityForResult(intent, 1337);
                } catch (JSONException e) {
                    handleResponseError("Bad json format \n" + e.getMessage());
                }
            } else {
                handleResponseError(String.format("Checkout error due to <%s>", response.message()));
            }
        }
    }

    private class PaymentStatusCallback implements Callback {
        @Override
        public void onFailure(Call call, IOException e) {
            Toast.makeText(CheckoutActivity.this, "Error: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }

        @Override
        @SuppressWarnings("deprecated")
        public void onResponse(Call call, Response response) throws IOException {
            showSpinner(false);
            if (response.isSuccessful()) {
                final String json = response.body().string();
                CheckoutActivity.this.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        findViewById(R.id.checkout_btn).setVisibility(View.GONE);
                        TextView view = (TextView) findViewById(R.id.text_view);
                        view.setText(String.format(
                                "Payment outcome from mCASH: \n %s", json));
                    }
                });
            }
        }
    }
}
