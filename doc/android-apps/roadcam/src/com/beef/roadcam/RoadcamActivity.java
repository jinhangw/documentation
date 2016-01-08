package com.beef.roadcam;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import android.app.Activity;
import android.content.Context;
import android.hardware.Camera;
import android.hardware.Camera.AutoFocusCallback;
import android.hardware.Camera.PictureCallback;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.media.ExifInterface;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.TextView;

public class RoadcamActivity extends Activity implements SensorEventListener {
	Button _start, capture;
	RoadcamActivity self = this;
	String TAG = "RoadcamActivity Error";
	CameraPreview camSurface;
	Camera.Parameters mParams;
	ExifInterface mExif;
	MyLocation my_location;
	Context context;
	String latitude, longitude, latD, longD;
	Boolean tagged, timerRunning;
	int currentTime;
	Handler timerUpdateHandler;
	int SECONDS_BETWEEN_PHOTOS = 2;
	SensorManager sensorManager;
	TextView textView;
	LocationManager locationManager;
	Location gpsLocation;
	Location netLocation;
	static String tempDir;
	float accelx[] = new float[2];
	float accely[] = new float[2];
	float accelz[] = new float[2];
	float orientation = 0;
	String imageFolder;
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        camSurface = new CameraPreview(self);
        _start = (Button) findViewById(R.id.start);
        _start.setOnClickListener(start_handler);
        context = this;
        tagged = false;
        timerRunning = false;
        currentTime = 0;
        timerUpdateHandler = new Handler();
        locationManager = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
        locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, locationListenerNET);
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, locationListenerGPS);
        sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
		sensorManager.registerListener(this,
				sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
				SensorManager.SENSOR_DELAY_NORMAL);
		sensorManager.registerListener(this,
				sensorManager.getDefaultSensor(Sensor.TYPE_ORIENTATION),
				sensorManager.SENSOR_DELAY_NORMAL);
    }
    
    View.OnClickListener start_handler = new View.OnClickListener() {
        public void onClick(View v) {
        	setContentView(R.layout.preview);
        	FrameLayout preview = (FrameLayout) findViewById(R.id.preview);
        	preview.addView(camSurface);
        	capture = (Button) findViewById(R.id.capture);
        	capture.setOnClickListener(capture_handler);
			tempDir = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
			tempDir = "/" + tempDir;
        }
    };
    
    LocationListener locationListenerGPS = new LocationListener() {
    	public void onLocationChanged(Location location) {
    		gpsLocation = location;
    	}

		@Override
		public void onProviderDisabled(String provider) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onProviderEnabled(String provider) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onStatusChanged(String provider, int status, Bundle extras) {
			// TODO Auto-generated method stub
			
		}
    };

    LocationListener locationListenerNET = new LocationListener() {
    	public void onLocationChanged(Location location) {
    		netLocation = location;
    	}

		@Override
		public void onProviderDisabled(String provider) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onProviderEnabled(String provider) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onStatusChanged(String provider, int status, Bundle extras) {
			// TODO Auto-generated method stub
			
		}
    };

	public void gotLocation(Location location) {
	   	double ilong = location.getLongitude();
	   	double ilat = location.getLatitude();
	   	if (ilong < 0) {
	   		longD = "E";
	   	} else {
	   		longD = "W";
	   	}
	   	if (ilat < 0) {
	   		latD = "S";
	   	} else {
	   		latD = "N";
	   	}
	   	latitude = convertDegrees(ilat);
	   	longitude = convertDegrees(ilong);
	}

	public String convertDegrees(double location) {
		if (location < 0) { location = location * -1; }
		int degrees = (int) location;
		location = 60 * (location - degrees);
		int minutes = (int) location;
		location = 60 * (location - minutes);
		int seconds = (int) location;
		return degrees + "/1," + minutes + "/1," + seconds + "/1";
	}
    
	private Runnable timerUpdateTask = new Runnable() {
		public void run() {
			if (currentTime < SECONDS_BETWEEN_PHOTOS) {
				currentTime++;
			} else {
				shootCamera();
				currentTime = 0;
			}
			timerUpdateHandler.postDelayed(timerUpdateTask, 1000);
		}
	};
	
    View.OnClickListener capture_handler = new View.OnClickListener() {
		@Override
		public void onClick(View v) {
			if (!timerRunning) {
				tempDir = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
				tempDir = "/" + tempDir;
				timerRunning = true;
				Camera temp = camSurface.getCamera();
				capture.setText("Stop");
				temp.autoFocus(myAutoFocusCallback);
				
			}	
			else {
				timerRunning = false;
				timerUpdateHandler.removeCallbacks(timerUpdateTask);
				capture.setText("Start");
			}
		}
	};
	/*
	View.OnClickListener capture_handler = new View.OnClickListener() {
		
		@Override
		public void onClick(View v) {
			shootCamera();
		}
	};
	*/
	public void shootCamera() {
		Camera mCam = camSurface.getCamera();
		mParams = mCam.getParameters();
		mCam.takePicture(null, null, jpegCallback);
		 
	}
	
	// This just gets called after the camera has finished autofocusing
	AutoFocusCallback myAutoFocusCallback = new AutoFocusCallback() {
		@Override
		public void onAutoFocus(boolean arg0, Camera arg1) {
			timerUpdateHandler.post(timerUpdateTask);
			//arg1.takePicture(null, null, jpegCallback); 
		}
	};
    
    PictureCallback jpegCallback = new PictureCallback() {
    	 @Override
    	 public void onPictureTaken(byte[] data, Camera camera) {
    		 System.out.println("" + data.length);
    		 File pictureFile = getOutputMediaFile();
    		 if (pictureFile == null){
    			 Log.d(TAG, "Error creating media file, check storage permissions: ");
    			 return;
    		 }
    		 try {
    			 FileOutputStream fos = new FileOutputStream(pictureFile);
    			 fos.write(data);
    			 fos.close();
    			 WriteExif(pictureFile.getPath(), mParams);
    		 } catch (FileNotFoundException e) {
    			 Log.d(TAG, "File not found: " + e.getMessage());
    		 } catch (IOException e) {
    			 Log.d(TAG, "Error accessing file: " + e.getMessage());
    		 }
    	 }
    };
    
    private void writeImageData(String text) throws IOException {
    	String picDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getPath() + "/MyCameraApp" + tempDir + tempDir + ".txt";
    	FileWriter f = new FileWriter(picDir, true);
    	System.out.println(picDir);
    	f.write(text);
    	f.close();
    }

    /** Create a File for saving an image or video */
    private static File getOutputMediaFile(){
        // To be safe, you should check that the SDCard is mounted
        // using Environment.getExternalStorageState() before doing this.
    	File mediaStorageDir = new File(Environment.getExternalStoragePublicDirectory(
    			Environment.DIRECTORY_PICTURES), "MyCameraApp" + tempDir);
        // This location works best if you want the created images to be shared
        // between applications and persist after your app has been uninstalled.

        // Create the storage directory if it does not exist
        if (! mediaStorageDir.exists()){
            if (! mediaStorageDir.mkdirs()){
                Log.d("MyCameraApp" + tempDir, "s");
                return null;
            }
        }

        // Create a media file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        File mediaFile;        
        mediaFile = new File(mediaStorageDir.getPath() + File.separator +
        		"IMG_"+ timeStamp + ".jpg");
        return mediaFile;
    }
    
    protected void WriteExif(String fileName, Camera.Parameters tParams) throws IOException {
    	if (gpsLocation == null) {
    		if (netLocation == null) {
    			longitude = "0";
    			latitude = "0";
    			latD = "N";
    			longD = "S";
    		}
    		else {
    			longitude = "" + netLocation.getLongitude();
    			latitude = "" + netLocation.getLatitude();
    		}
    	}
    	else {
			longitude = "" + gpsLocation.getLongitude();
			latitude = "" + gpsLocation.getLatitude();
    	}
    	float[] results = {0, 0, 0};
    	mParams.getFocusDistances(results);
    	writeImageData(fileName.substring(fileName.lastIndexOf("/")+1) + "||" + longitude + ", " + latitude + "||" + orientation + "||" + results[0] + ", " + results[1] + ", " + results[2] + "||" + accelx[0] + ", " + accely[0] + ", " + accelz[0] + "\n");
    	ExifInterface exifInterface = new ExifInterface(fileName);
    	System.out.println("D = " + results[0] + ", " + results[1] + ", " + results[2]);
    //	exifInterface.setAttribute(ExifInterface.TAG_GPS_LONGITUDE, longitude);
    //	exifInterface.setAttribute(ExifInterface.TAG_GPS_LONGITUDE_REF, longD);
    //	exifInterface.setAttribute(ExifInterface.TAG_GPS_LATITUDE, latitude);
    //	exifInterface.setAttribute(ExifInterface.TAG_GPS_LATITUDE_REF, latD);
    	exifInterface.setAttribute(ExifInterface.TAG_MAKE, "D = " + results[0] + ", " + results[1] + ", " + results[2]);
    	exifInterface.setAttribute(ExifInterface.TAG_MODEL, "" + orientation);
    	exifInterface.setAttribute(ExifInterface.TAG_DATETIME, "" + mParams.getVerticalViewAngle());
		exifInterface.saveAttributes();
    }

	@Override
	public void onAccuracyChanged(Sensor arg0, int arg1) {
		
	}

	@Override
	public void onSensorChanged(SensorEvent event) {
		if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
			getAccelerometer(event);
		}
		else if(event.sensor.getType() == Sensor.TYPE_ORIENTATION) {
			getOrientation(event);
		}
	}
	
	private void getOrientation(SensorEvent event) {
		orientation = event.values[0];
	}
	
	private void getAccelerometer(SensorEvent event) {
		accelx[0] = accelx[1];
		accely[0] = accely[1];
		accelz[0] = accelz[1];
		accelx[1] = event.values[0];
		accely[1] = event.values[1];
		accelz[1] = event.values[2];
		lowPassFilter();
	}
	
	private void lowPassFilter() {
		;
	}
	 
	@Override
	protected void onResume() {
		super.onResume();
		sensorManager.registerListener(this,
				sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
				SensorManager.SENSOR_DELAY_NORMAL);
	}
	
	@Override
	protected void onPause() {
		super.onPause();
		locationManager.removeUpdates(locationListenerGPS);
		locationManager.removeUpdates(locationListenerNET);
		sensorManager.unregisterListener(this);
	}
	
}