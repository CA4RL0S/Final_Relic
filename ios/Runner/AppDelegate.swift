import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Fondo oscuro para eliminar flash de color al iniciar
    self.window?.backgroundColor = UIColor(red: 13.0/255.0, green: 13.0/255.0, blue: 26.0/255.0, alpha: 1.0)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
