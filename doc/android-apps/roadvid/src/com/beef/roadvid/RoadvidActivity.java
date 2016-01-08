package com.beef.roadvid;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import android.app.Activity;
import android.content.Context;
import android.hardware.Camera;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.media.CamcorderProfile;
import android.media.MediaRecorder;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;

public class RoadvidActivity extends Activity {
	Button capture;
	
	Handler timerUpdateHandler;
	
    Camera mCamera;
    CameraPreview mPreview;
    private MediaRecorder mMediaRecorder;
    private boolean isRecording = false;
    
    LocationManager locationManager;
	Location gpsLocation;
	Location netLocation;
	String longitude, latitude;

	static String tempdir;
	/** Called when the activity is first created. */
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        timerUpdateHandler = new Handler();
        capture = (Button) findViewById(R.id.button_capture);
        capture.setOnClickListener(capture_handler);
        mCamera = getCameraInstance();
        mPreview = new CameraPreview(this, mCamera);
        FrameLayout preview = (FrameLayout) findViewById(R.id.camera_preview);
        preview.addView(mPreview);
        locationManager = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
        locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, locationListenerNET);
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, locationListenerGPS);
    }
    
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
	
	private Runnable timerUpdateTask = new Runnable() {
		public void run() {
			try {
				if (gpsLocation == null) {
		    		if (netLocation == null) {
		    			longitude = "0";
		    			latitude = "0";
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
				writeImageData(longitude + ", " + latitude  + "\n");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			timerUpdateHandler.postDelayed(timerUpdateTask, 100);
		}
	};
	
	View.OnClickListener capture_handler = new View.OnClickListener() {
		@Override
		public void onClick(View v) {
			if (isRecording) {
				// stop recording and release camera
                mMediaRecorder.stop();  // stop the recording
                releaseMediaRecorder(); // release the MediaRecorder object
                mCamera.lock();         // take camera access back from MediaRecorder

                // inform the user that recording has stopped
                capture.setText("Capture");
                isRecording = false;
                timerUpdateHandler.removeCallbacks(timerUpdateTask);
            } else {
            	tempdir = "/" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
                // initialize video camera
                if (prepareVideoRecorder()) {
                    // Camera is available and unlocked, MediaRecorder is prepared,
                    // now you can start recording
                	
                    mMediaRecorder.start();
                    // inform the user that recording has started
                    capture.setText("Stop");
                    isRecording = true;
                    timerUpdateHandler.post(timerUpdateTask);
                } else {
                    // prepare didn't work, release the camera
                    releaseMediaRecorder();
                    // inform user
                }
            }
		}
	};
	
	private void writeImageData(String text) throws IOException {
    	String picDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getPath() + "/MyCameraApp" + tempdir + tempdir + ".txt";
    	FileWriter f = new FileWriter(picDir, true);
    	System.out.println(picDir);
    	f.write(text);
    	f.close();
    }
	
    /** A safe way to get an instance of the Camera object. */
    public static Camera getCameraInstance() {
        Camera c = null;
        try {
            c = Camera.open(); // attempt to get a Camera instance
        }
        catch (Exception e)	{
        	System.out.println(e);
            // Camera is not available (in use or does not exist)
        }
        return c; // returns null if camera is unavailable
    }
    
    /** Prepare the Camera with video settings */
    private boolean prepareVideoRecorder(){

        mMediaRecorder = new MediaRecorder();
        
        // Step 1: Unlock and set camera to MediaRecorder
        mCamera.unlock();
        mMediaRecorder.setCamera(mCamera);

        // Step 2: Set sources
    //    mMediaRecorder.setAudioSource(MediaRecorder.AudioSource.CAMCORDER);
        mMediaRecorder.setVideoSource(MediaRecorder.VideoSource.CAMERA);

        // Step 3: Set a CamcorderProfile (requires API Level 8 or higher)
        mMediaRecorder.setProfile(CamcorderProfile.get(CamcorderProfile.QUALITY_TIME_LAPSE_HIGH));
        
        // Step 4: Set output file
        mMediaRecorder.setOutputFile(getOutputMediaFile().toString());

        // Step 5: Set the preview output
        mMediaRecorder.setPreviewDisplay(mPreview.getHolder().getSurface());
        mMediaRecorder.setCaptureRate(10);

        // Step 6: Prepare configured MediaRecorder
        try {
            mMediaRecorder.prepare();
        } catch (IllegalStateException e) {
            Log.d("Preparing video camera", "IllegalStateException preparing MediaRecorder: " + e.getMessage());
            releaseMediaRecorder();
            return false;
        } catch (IOException e) {
            Log.d("Preparing video camera", "IOException preparing MediaRecorder: " + e.getMessage());
            releaseMediaRecorder();
            return false;
        }
        return true;
    }
    
    /** Create a File for saving an image or video */
    private static File getOutputMediaFile() {
        // To be safe, you should check that the SDCard is mounted
        // using Environment.getExternalStorageState() before doing this.

        File mediaStorageDir = new File(Environment.getExternalStoragePublicDirectory(
                  Environment.DIRECTORY_PICTURES), "MyCameraApp" + tempdir);
        // This location works best if you want the created images to be shared
        // between applications and persist after your app has been uninstalled.

        // Create the storage directory if it does not exist
        if (! mediaStorageDir.exists()){
            if (! mediaStorageDir.mkdirs()){
                Log.d("MyCameraApp", "failed to create directory");
                return null;
            }
        }

        // Create a media file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        File mediaFile;
        mediaFile = new File(mediaStorageDir.getPath() + File.separator +
        		"VID_"+ timeStamp + ".mp4");
        return mediaFile;
    }
    
    
    protected void onPause() {
        super.onPause();
        locationManager.removeUpdates(locationListenerGPS);
		locationManager.removeUpdates(locationListenerNET);
        releaseMediaRecorder();       // if you are using MediaRecorder, release it first
        releaseCamera();              // release the camera immediately on pause event
    }

    private void releaseMediaRecorder(){
        if (mMediaRecorder != null) {
            mMediaRecorder.reset();   // clear recorder configuration
            mMediaRecorder.release(); // release the recorder object
            mMediaRecorder = null;
            mCamera.lock();           // lock camera for later use
        }
    }

    private void releaseCamera(){
        if (mCamera != null){
            mCamera.release();        // release the camera for other applications
            mCamera = null;
        }
    }
}