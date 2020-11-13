
import UIKit
import RealmSwift

// MARK: Enums

enum Currency: String, RealmEnum {
    case none = ""
    case ruble = "₽"
    case euro =  "€"
    case dollar = "$"
}

// MARK: - Protocols

protocol SpentMoneyViewControllerDelegate {
    func spent(money: Double, currency: Currency)
}

class SpentMoneyViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var segmentMoney: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var readyButton: UIButton!
    
    
    // MARK: - Properties
    
    var delegate: SpentMoneyViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    
    @IBAction func doneClicked(_ sender: Any) {
        if let text = textField.text, let money = Double(text) {
            var currency: Currency = .none
            switch segmentMoney.selectedSegmentIndex {
            case 0:
                currency = .dollar
            case 1:
                currency = .euro
            case 2:
                currency = .ruble
            default:
                break
            }
            delegate?.spent(money: money, currency: currency)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func hideKeyboardByTap() {
        view.endEditing(true)
    }
    
    // MARK: - Functions
    
    func configureUI() {
        readyButton.layer.cornerRadius = 8
        textField.layer.cornerRadius = 6
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboardByTap)))
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
    }
}
