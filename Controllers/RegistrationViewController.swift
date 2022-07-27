import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.layer.cornerRadius = 4
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboardByTap)))
    }
    
    // MARK: - Actions
    
    @IBAction private func didTapCreateButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, _) in
            guard let self = self else { return }
            var message: String = ""
            if user != nil {
                message = "User was sucessfully created."
                
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
    
    @objc func hideKeyboardByTap() {
        view.endEditing(true)
    }
}
