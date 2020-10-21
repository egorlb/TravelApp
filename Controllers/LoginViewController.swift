
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - Variables
    
    var message: String = ""
    var iconBtn = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    
    // MARK: - Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = 4
    }
    
    // MARK: - Actions
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, _) in
            var message: String = ""
            if user != nil {
                message = "User was sucessfully logged in."
                
                let createStop = TravelListViewController.fromStoryboard() as! TravelListViewController
                self.navigationController?.pushViewController(createStop, animated: true)
            } else {
                message = "There was an error."
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        sender.setAnimationForButton()
    }
    
    @IBAction func changeIcon(_ sender: UIButton) {
        if iconBtn {
            iconImage.image = UIImage(systemName: "eye")
            iconBtn = false
            passwordTextField.isSecureTextEntry = false
        } else {
            iconImage.image = UIImage(systemName: "eye.slash")
            iconBtn = true
            passwordTextField.isSecureTextEntry = true
        }
    }
}

