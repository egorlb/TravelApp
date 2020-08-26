



import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Variables
    
    var iconBtn = false

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    
    // MARK: - Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = 4
    }
    
    // MARK: - Actions
    
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


