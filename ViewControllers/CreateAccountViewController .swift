
import UIKit

class CreateAccountViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var createButton: UIButton!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.layer.cornerRadius = 4

    }
    
    // MARK: - Actions
    @IBAction func createAnAccount(_ sender: UIButton) {
        sender.setAnimationForButton()
    }
}

