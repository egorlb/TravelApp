
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
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboardByTap)))
    }
    
    // MARK: - Actions
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, _) in
            guard let self = self else { return }
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
    
    @IBAction func hidePasswordEntry(_ sender: UIButton) {
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
    
    @IBAction func didTapForgotPasswordButton(_ sender: Any) {
        let forgotVC = ForgotPasswordViewController.fromStoryboard() as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    @objc func hideKeyboardByTap() {
          view.endEditing(true)
      }
}


