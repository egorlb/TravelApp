
import UIKit
import Firebase
import FirebaseRemoteConfig
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        print("RealmFile:", Realm.Configuration.defaultConfiguration.fileURL)
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
            do {
                try Auth.auth().signOut()
            } catch {
                error.localizedDescription
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

