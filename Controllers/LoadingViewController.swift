
import UIKit
import Firebase
import FirebaseAuth
import FirebaseRemoteConfig


class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { [weak self] (status, error) in
            DispatchQueue.main.async { [weak self] in
                if let user = Auth.auth().currentUser?.uid {
                    self?.showTravelList()
                } else {
                    self?.showWelcomeScreen()
                }
            }
        }
    }
    
    func showWelcomeScreen() {
        let welcomeVC  = WelcomeViewController.fromStoryboard() as! WelcomeViewController
        self.navigationController?.pushViewController(welcomeVC, animated: true)
    }
    
    func showTravelList() {
        let welcomeVC  = TravelListViewController.fromStoryboard() as! TravelListViewController
        self.navigationController?.pushViewController(welcomeVC, animated: true)
    }
}
