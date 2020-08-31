

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPropertiesButton()
    }
    
    // MARK: - Actions
    
    @IBAction func createAccount(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    // MARK: - Functions
    
    func setPropertiesButton() {
        loginButton.layer.cornerRadius = 4
        createButton.layer.cornerRadius = 4
    }
}



