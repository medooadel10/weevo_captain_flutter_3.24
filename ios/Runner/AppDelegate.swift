import UIKit
import Flutter
import Firebase
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
FirebaseApp.configure()
      GMSServices.provideAPIKey("AIzaSyCFEJSLahBCQGpt-97cEYymIeraGH7kbrw")
      GeneratedPluginRegistrant.register(with: self)
           if #available(iOS 10.0, *) {
                     UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
                   }
                   application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}