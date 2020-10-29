
import UIKit
import Firebase
import FirebaseRemoteConfig


class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { (status, error) in
            DispatchQueue.main.async {
                self.showWelcomeScreen()
            }
        }
    }
    
    func showWelcomeScreen() {
        let welcomeVC  = WelcomeViewController.fromStoryboard() as! WelcomeViewController
        self.navigationController?.pushViewController(welcomeVC, animated: true)
    }
}
