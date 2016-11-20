package example.mcash.com.appswitch;


import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;

/**
 * Simple HTTP wrapper.
 */
public class PaymentApi {
    private static final String API_URL = "http://88f1d8fa.ngrok.io";
    private static PaymentApi instance;
    private OkHttpClient client;

    private PaymentApi() {
        client = new OkHttpClient();
    }

    public static PaymentApi getInstance() {
        if (instance == null)
            instance = new PaymentApi();
        return instance;
    }

    public void createPaymentRequest(Callback callback) {
        Request request = new Request.Builder()
                .url(API_URL + "/payment")
                .header("Content-Type", "application/json")
                .get()
                .build();

        client.newCall(request).enqueue(callback);
    }

    public void getPaymentStatus(Callback callback, String tid) {
        Request request = new Request.Builder()
                .url(API_URL + "/payment/" + tid)
                .header("Content-Type", "application/json")
                .get()
                .build();

        client.newCall(request).enqueue(callback);
    }
}

