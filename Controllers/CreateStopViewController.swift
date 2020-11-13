
import UIKit
import FirebaseDatabase

protocol CreateStopViewControllerDelegate {
    func didCreate(stop: Stop)
    func didUpdate(stop: Stop)
}

class CreateStopViewController: UIViewController, SpentMoneyViewControllerDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var spentMoneyLabel: UILabel!
    @IBOutlet weak var stepperView: UIView!
    @IBOutlet weak var chooseTransportSegmentedControl: UISegmentedControl!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var stopNameTextField: UITextField!
    @IBOutlet weak var dotsAnimationIndicator: DotsActivityIndicator!
    
    // MARK: - Properties
    private let nameController = "Остановка"
    var count = 0
    var travelId: String = ""
    var selectedMoney: String = ""
    var selectedCurrency: Currency = .none
    var selectedLocation: CGPoint = .zero
    var stop: Stop?
    var delegate: CreateStopViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        if let stop = stop {
            spentMoneyLabel.text = String(stop.spentMoney)
            stopNameTextField.text = stop.name
            rateLabel.text = String(stop.rate)
            descriptionTextView.text = stop.description
            selectedMoney = stop.spentMoney
            selectedCurrency = stop.currency
            locationLabel.text = "\(stop.location.x)-\(stop.location.y)"
            selectedLocation = stop.location
            
            switch stop.transport {
            case .airplane:
                chooseTransportSegmentedControl.selectedSegmentIndex = 0
            case .train:
                chooseTransportSegmentedControl.selectedSegmentIndex = 1
            case .car:
                chooseTransportSegmentedControl.selectedSegmentIndex = 2
            case .none:
                break
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func spentMoneyClicked(_ sender: Any) {
        let spentVC = SpentMoneyViewController.fromStoryboard() as! SpentMoneyViewController 
        spentVC.delegate = self
        present(spentVC, animated: true, completion: nil)
    }
    
    @IBAction func decreaseButtonRating(_ sender: Any) {
        if count > 0 {
            count -= 1
        }
        rateLabel.text = "\(count)"
    }
    
    @IBAction func increaseButtonRating(_ sender: Any) {
        if count < 5 {
            count += 1
            rateLabel.text = "\(count)"
        }
    }
    
    @objc func saveClickedButton(sender: UIBarButtonItem) {
        if let stop = stop {
            updateStop(stop: stop)
            delegate?.didUpdate(stop: stop)
            sendToServer(stop: stop)
        } else {
            let id = UUID().uuidString
            let stop = Stop(id: id, travelId: travelId)
            updateStop(stop: stop)
            delegate?.didCreate(stop: stop)
            sendToServer(stop: stop)
        }
        dotsAnimationIndicator.startAnimation()
        dotsAnimationIndicator.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
            guard let self = self else { return }
            self.dotsAnimationIndicator.stopAnimation()
            self.navigationController?.popViewController(animated: true )
        })
    }

    @objc func hideKeyboardByTap() {
             view.endEditing(true)
         }
    
    @IBAction func mapClicked(_ sender: Any) {
        let mapVC = MapViewController.fromStoryboard() as! MapViewController
        navigationController?.pushViewController(mapVC, animated: true)
        
        mapVC.closure = { point in
            self.locationLabel.text = "\(point.x) - \(point.y)"
        }
    }
    
    // MARK: - Functions
    
    func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveClickedButton(sender:)))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboardByTap)))
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 20, right: 12)
        stepperView.layer.borderWidth = 1
        stepperView.layer.borderColor = UIColor(named: "purple")?.cgColor
        stepperView.layer.cornerRadius = 4
        self.title = nameController
    }
    
    func spent(money: Double, currency: Currency) {
        spentMoneyLabel.text = String(money) + currency.rawValue
        selectedMoney = String(money)
        selectedCurrency = currency
    }
    
    func updateStop(stop: Stop) {
        if let rating = rateLabel.text, let changeRating = Int(rating) {
            stop.rate = changeRating
        }
        if let name = stopNameTextField.text {
            stop.name = name
        }
        if let spentMoney = spentMoneyLabel.text {
            stop.spentMoney = spentMoney
        }
        stop.location = selectedLocation
        stop.spentMoney = selectedMoney
        stop.currency = selectedCurrency
        stop.description = descriptionTextView.text
        
        switch chooseTransportSegmentedControl.selectedSegmentIndex {
        case 0:
            stop.transport = .airplane
        case 1:
            stop.transport = .train
        case 2:
            stop.transport = .car
        default:
            break
        }
    }
    
    func sendToServer(stop: Stop) {
        let database = Database.database().reference()
        let child = database.child("stops").child("\(stop.id)")
        child.setValue(stop.json) { (error, ref) in
            if let newerror = error {
                print(newerror,ref)
            }
        }
    }
}
