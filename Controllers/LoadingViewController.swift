import UIKit
import Firebase
import FirebaseAuth
import FirebaseRemoteConfig

class LoadingViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRemoteConfg()
    }
    
    // MARK: - Private
    
    private func showWelcomeScreen() {
        let welcomeVC  = WelcomeViewController.fromStoryboard() as! WelcomeViewController
        self.navigationController?.pushViewController(welcomeVC, animated: true)
    }
    
    private func showTravelList() {
        let welcomeVC  = TravelListViewController.fromStoryboard() as! TravelListViewController
        self.navigationController?.pushViewController(welcomeVC, animated: true)
    }
    
    private func configureRemoteConfg() {
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
}
