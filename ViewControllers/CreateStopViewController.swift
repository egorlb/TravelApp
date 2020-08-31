import UIKit

class CreateStopViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var stepperView: UIView!
    @IBOutlet weak var chooseTransport: UISegmentedControl!
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepperView.layer.borderWidth = 1
        stepperView.layer.borderColor = #colorLiteral(red: 0.5137254902, green: 0.537254902, blue: 0.9098039216, alpha: 1)
        stepperView.layer.cornerRadius = 4
    }
}
