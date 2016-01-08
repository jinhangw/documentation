package com.beef.roadcam;

import java.io.IOException;
import java.util.List;

import android.content.Context;
import android.view.SurfaceView;
import android.view.SurfaceHolder;
import android.hardware.Camera;

/**
 * 
 * @author openmobster@gmail.com
 */
public class CameraPreview extends SurfaceView implements SurfaceHolder.Callback {
	private SurfaceHolder holder;
	private Camera camera;
	public CameraPreview(Context context) {
		super(context);
		this.holder = this.getHolder();
		this.holder.addCallback(this);
		this.holder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
	}
	
	@Override
	public void surfaceCreated(SurfaceHolder holder) {
		try {
			this.camera = Camera.open();
			this.camera.setPreviewDisplay(this.holder);
		} catch(IOException ioe) {
			ioe.printStackTrace(System.out);
		}
	}

	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
		Camera.Parameters parameters = camera.getParameters();
	    List<Camera.Size> previewSizes = parameters.getSupportedPreviewSizes();
	    List<Camera.Size> pictureSizes = parameters.getSupportedPictureSizes();
	    // You need to choose the most appropriate previewSize for your app
	    Camera.Size previewSize = (Camera.Size) previewSizes.get(2);
	    Camera.Size pictureSize = (Camera.Size) pictureSizes.get(0); 
	    System.out.println("" + pictureSize.height + ", " + pictureSize.width);
	    parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
        parameters.setPictureSize(pictureSize.width, pictureSize.height);

		camera.setDisplayOrientation(90);
	    parameters.setPreviewSize(previewSize.width, previewSize.height);
	    camera.setParameters(parameters);
	    camera.startPreview();
	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
		// Surface will be destroyed when replaced with a new screen
		//Always make sure to release the Camera instance
		camera.stopPreview();
		camera.release();
		camera = null;
	}
	
	public Camera getCamera() {
		return this.camera;
	}
}