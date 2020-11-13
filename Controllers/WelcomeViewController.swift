

import UIKit
import FirebaseRemoteConfig

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let loginText = remoteConfig["loginButtonText"].stringValue
        loginButton.setTitle(loginText, for: .normal)
        let isNeedToShowLoginButton = remoteConfig["isNeedToShowLoginButton"].boolValue
        if isNeedToShowLoginButton == false {
            loginButton.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func createAccount(_ sender: UIButton) {
        let createAccount = RegistrationViewController.fromStoryboard() as! RegistrationViewController
        self.navigationController?.pushViewController(createAccount, animated: true)
    }
    
    @IBAction func clickedLogin(_ sender: UIButton) {
        let loginVC = LoginViewController.fromStoryboard() as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    // MARK: - Functions
    
    func configureUI() {
        loginButton.layer.cornerRadius = 4
        createButton.layer.cornerRadius = 4
        self.navigationController?.navigationBar.tintColor = UIColor(named: "purple")
        self.navigationItem.hidesBackButton = true
    }
}



