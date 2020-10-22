
import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func didTapResetButton(_ sender: Any) {
        guard let email = emailTextField.text else {
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            var message: String = ""
            if email.isEmpty {
                message = "Please fill out this field."
            } else if error != nil {
                message = "Please provide a properly formatted email address."
            } else {
                message = "Reset email has been sent to your login email, please follow the instructions in the mail to reset your password."
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
