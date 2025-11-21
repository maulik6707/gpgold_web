import UIKit
import FirebaseMessaging
import GoogleMaps
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCt44CmiwBJ8jU4pQkj_GfkbPcicI4h7-Y")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(
      _ application: UIApplication,
      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        print("didReceiveRemoteNotification \(userInfo)")
        Messaging.serviceExtension().exportDeliveryMetricsToBigQuery(withMessageInfo: userInfo)
    }
}
