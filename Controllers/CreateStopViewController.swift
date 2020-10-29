import UIKit
import FirebaseDatabase
protocol CreateStopViewControllerDelegate {
    func didCreate(stop: Stop)
}

class CreateStopViewController: UIViewController, SpentMoneyViewControllerDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var spentMoneyLabel: UILabel!
    @IBOutlet weak var stepperView: UIView!
    @IBOutlet weak var chooseTransportSegmentedControl: UISegmentedControl!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Properties
    
    var count = 0
    var travelId: String = ""
    var money: Double = 0
    var stop: Stop?
    var delegate: CreateStopViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepperView.layer.borderWidth = 1
        stepperView.layer.borderColor = UIColor(named: "purple")?.cgColor
        stepperView.layer.cornerRadius = 4
        
        setupPropertiesForNavigationBar()
        
        if let stop = stop {
            spentMoneyLabel.text = String(stop.spentMoney)
            nameTextField.text = stop.name
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
            sendToServer(stop: stop)
        } else {
            let id = UUID().uuidString
            let stop = Stop(id: id, travelId: travelId)
            updateStop(stop: stop)
            
            delegate?.didCreate(stop: stop)
            sendToServer(stop: stop)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func transportSegmented(_ sender: Any) {
    }
    
    @IBAction func mapClicked(_ sender: Any) {
        let mapVC = MapViewController.fromStoryboard() as! MapViewController
        navigationController?.pushViewController(mapVC, animated: true)
        
        mapVC.closure = { point in
            self.locationLabel.text = "\(point.x) - \(point.y)"
        }
    }
    
    // MARK: - Functions
    
    func setupPropertiesForNavigationBar() {
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveClickedButton(sender:)))
    }
    
    func spent(money: Double, currency: Currency) {
        spentMoneyLabel.text = String(money) + currency.rawValue
        self.money = money
    }
    
    func updateStop(stop: Stop) {
        if let rating = rateLabel.text, let changeRating = Int(rating) {
            stop.rate = changeRating
        }
        if let name = nameTextField.text {
            stop.name = name
        }
        if let spentMoney = spentMoneyLabel.text {
            stop.spentMoney = spentMoney
        }
        stop.location = .zero
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
    
    func sendToServer(stop: Stop)  {
        let database = Database.database().reference()
        let child = database.child("stops").child("\(stop.id)")
        child.setValue(stop.json) { (error, ref) in
            if let newerror = error {
                print(newerror,ref)
            }
        }
    }
}
