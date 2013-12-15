package com.herrington.InventoryScanner;

import android.net.Uri;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

public class Scanner extends Activity implements OnClickListener {

	//UI instance variables
	private Button scanBtn, websiteBtn;
	private TextView formatTxt, contentTxt;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_scanner);

		//instantiate UI items
		scanBtn = (Button)findViewById(R.id.scan_button);
		formatTxt = (TextView)findViewById(R.id.scan_format);
		contentTxt = (TextView)findViewById(R.id.scan_content);
		contentTxt.setText(null);
		websiteBtn = (Button) findViewById(R.id.website_button);
		websiteBtn.setText("Insert");
		//listen for clicks
		scanBtn.setOnClickListener(this);
		websiteBtn.setOnClickListener(this);
	}

	public void onClick(View v){
		//check for scan button
		if(v.getId()==R.id.scan_button){
			//instantiate ZXing integration class
			IntentIntegrator scanIntegrator = new IntentIntegrator(this);
			//start scanning
			scanIntegrator.initiateScan();
		}
		if(v.getId()==R.id.website_button){
			if (contentTxt.getText() !=null){
				//Create client and post values
				HttpClient client = new DefaultHttpClient();
				HttpPost post = new HttpPost("http://scanner419.appspot.com/android");

				//This is the general way to do it... 
				List<NameValuePair> pairs = new ArrayList<NameValuePair>();
				pairs.add(new BasicNameValuePair("barcode", contentTxt.getText()));
				post.setEntity(new UrlEncodedFormEntity(pairs));

				//should check response here... for errors	
				HttpResponse response = client.execute(post);

        		//Uri url = Uri.parse("http://scanner419.appspot.com/android?barcode="+contentTxt.getText());
        		Intent browserIntent = new Intent(Intent.ACTION_VIEW, "http://scanner419.appspot.com/android" );
        		startActivity(browserIntent);  
        	}
		}
	
	}

	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		IntentResult scanningResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, intent);
		if (scanningResult != null) {
			String scanContent = scanningResult.getContents();
			String scanFormat = scanningResult.getFormatName();
			formatTxt.setText("Format: "+scanFormat);
			contentTxt.setText("Result: "+scanContent);
		}
		else{
			//invalid scan data or scan canceled
			Toast toast = Toast.makeText(getApplicationContext(), 
					"No scan data received!", Toast.LENGTH_SHORT);
			toast.show();
		}
	}

}
