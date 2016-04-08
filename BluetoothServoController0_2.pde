/**
  * Emma Sutinen 4/2016
  * Adorable joystick-app for Android
  * using bluetooth to communicate between Android-device and a two-motored
  * microcontroller-device ie. Arduino. Does not work (yet).
  *
  * Built using Processing 3.0.2 - Android mode
  */

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.view.Gravity;
import android.widget.Toast;
import android.util.Log;

private final static int REQUEST_ENABLE_BT = 1;

float bx;
float by;
// Handler-coordinates
int boxSize = 50;
boolean locked = false;
//

float x;
float y;
float left;
float right;

void setup() {
  
  orientation(LANDSCAPE);
  fullScreen();
  bx = width/2.0;
  by = height/2.0;
  rectMode(RADIUS);
  stroke(255);
  fill(255, 0, 0);
  // Setup-configuration for the draw()-operand
  
  getBluetooth();
}

void getBluetooth() {
  
  BluetoothAdapter bluetooth = BluetoothAdapter.getDefaultAdapter();
  // Obtaining the BT-adapter of the device
  
/*BroadcastReceiver detective = new btDetective();
 *Detective-object for searching bluetooth-devices
 */  
  
  if (bluetooth == null) {
    println("This device does not support Bluetooth :(");
    // Device does not support Bluetooth :(
  }
  if (bluetooth != null && !bluetooth.isEnabled()) {
    Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
    startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
    // Requesting android to enable the adapter
  }
  /** Instance of the class BroadcastReceiver is statically registered inside
    * AndroidManifest.xml-file even though I made class.files for creating
    * objects to detect and receive Bluetooth-connections. :3
    */
}

void Toaster(String message) {
  Toast msg = Toast.makeText(getActivity().getApplicationContext(), message, Toast.LENGTH_LONG);
  msg.setGravity(Gravity.CENTER, 0, 0);
  msg.show();
}
// Toaster for making pop-ups when needed.

void draw() { 
  background(0, 0, 255);
  
  fill(0);
  rect(width/4, height/4, width/4.2, height/4.2);
  rect(width-(width/4), height/4, width/4.2, height/4.2);
  rect(width/4, height-(height/4), width/4.2, height/4.2);
  rect(width-(width/4), height-(height/4), width/4.2, height/4.2);
  // Portioning the area into neat little coordinate-system.
  
  fill(0, 255, 0);
  rect(bx, by, boxSize, boxSize, 5, 5, 5, 5);
  
  sendSerial();
}

void mousePressed() {
  locked = true; 
  moveBox();
}

void mouseDragged() {
  if(locked) {
    moveBox(); 
  }
}

void mouseReleased() {
  locked = false;
  centerBox();
}

void moveBox() {
  bx = mouseX;
  by = mouseY; 
  if (bx < 0.0) {
    bx = 0.0;
  }
  else if (bx > width) {
    bx = width; 
  }
  if (by < 0.0) {
    by = 0.0; 
  }
  else if (by > height) {
    by = height; 
  }
  // The location of your finger determines the coordinates and whereby the two motors spin.
}

void centerBox() {
  bx = width/2.0;
  by = height/2.0;
  // Set the coordinates of the handler to start-position (center).
}

void sendSerial() {
  x = (bx/2-90)/180;
  y = -(by/2-90)/90;
  // Setting the x & y -coordinates in between -1 & 1.
 
  if( (x >= 0 && y >= 0) || (x < 0 &&  y < 0) ) {
    left = max(abs(y),abs(x));
    right = (((-1 + (((acos(abs(x)/sqrt(x*x + y*y)))*180/PI)/90)*2) * abs(abs(y) - abs(x)))*100)/100;
  }
  else {
    right = max(abs(y),abs(x));
    left = (((-1 + (((acos(abs(x)/sqrt(x*x + y*y)))*180/PI)/90)*2) * abs(abs(y) - abs(x)))*100)/100; 
  }
  /* Turns the coordinate-system 45 degrees, so when you pull the handler-box way up, 
   * both of the motors spin at the same rate. Left motor spins slower when dragging right and so on.
   */
  left = left*25;
  right = right*25;
 
  if (y < 0) {
    left = -1*left;
    right = -1*right;
  }
 
  left = (left+25)*10;
  right = (right+25)*10;
  /* Scaling the values in between 0-255.
   * The value is proportional to the speed of the servo.
   */
  if (Float.isNaN(right)) {
    right=250;
  }
  if (Float.isNaN(left)) {
    left=250;
  } // .isNaN returns true, if the value of the Float is Not-a-Number.
 
  //println("x= "+x);
  //println("y= "+y);
  //println("L= "+left);
  //println("R= "+right);
 
  //println("L"+str(int(left))+"XR"+str(int(right))+"X");
  println("R"+str(int(left))+"XL"+str(int(right))+"X");  // <---------!!!!!!!!!!!!! data to write on Arduino !!!!!!!!!!!! 
}

/*
- fix the size-ratio
- http://solderer.tv/data-transfer-between-android-and-arduino-via-bluetooth/ <-- something equivalent for processing.Serial-package
- 

*/