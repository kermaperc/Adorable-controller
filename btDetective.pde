/**
  * Detective class for searching and printing available Bluetooth-devices
  */
public class btDetective extends BroadcastReceiver {
  @Override
  public void onReceive(Context context, Intent intent) {
    String detectedDevice = intent.getStringExtra(BluetoothDevice.EXTRA_NAME);
    
    Toaster("Detected: " + detectedDevice);
  }
}