Installation
=================

```
make && make run
```

Tip: sign up and download ngrok to setup a tunnel to your localhost (https://ngrok.com/download)


Start server
=================

`python server/server.py`

Set up tunnel to localhost
=================
`ngrok http -subdomain=<your_subdomain> 5000`

The following endpoints will now be available for your mobile apps:
- GET https://<your_subdomain>.ngrok.io/payment (Create payment request)
- GET https://<your_subdomain>.ngrok.io/payment/<transaction_id> (Payment status)



Payment request
=================
Create the payment request before doing app-switch.

```
GET https://<your_subdomain>.ngrok.io/payment (Create payment request)
Response: {"id": "p1234", "uri":"http://mca.sh/p/p1234"}
```


App-switch Android
==================

mcash://qr?code=http://mca.sh/p/p1234/


Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("mcash://qr?code=http://mca.sh/p/" + id + "/"));
startActivityForResult(intent, requestCode);


The mCASH-app does the following when payment is completed:

setResult(resultCode, intent);
finish();

Your app will then get a call back (and an appswitch) through the OS to onActivityResult(). resultCode can be either
RESULT_OK (-1) or RESULT_CANCELLED (0)


App-switch iOS
===================

```
Linking.openURL("mcash://qr?code=http://mca.sh/p/<tid>/&success_uri=appurl://success&failure_uri=appurl://failure")
```

where `http://mca.sh/p/<tid>/` and `<appurl://..>` must be urlencoded.



