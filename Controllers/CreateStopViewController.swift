import UIKit
import FirebaseDatabase
protocol CreateStopViewControllerDelegate {
    func didCreate(stop: Stop)
}

class CreateStopViewController: UIViewController, SpentMoneyViewControllerDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var spentMoney: UILabel!
    @IBOutlet weak var stepperView: UIView!
    @IBOutlet weak var chooseTransport: UISegmentedControl!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var chooseTransportBtnx: UISegmentedControl!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Properties
    
    var count = 0
    var stop: Stop?
    var delegate: CreateStopViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepperView.layer.borderWidth = 1
        stepperView.layer.borderColor = #colorLiteral(red: 0.5137254902, green: 0.537254902, blue: 0.9098039216, alpha: 1)
        stepperView.layer.cornerRadius = 4
        
        if let stop = stop {
            spentMoney.text = String(stop.spentMoney)
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
    
    @IBAction func saveClickedButton(_ sender: Any) {
        if stop != nil {
            stop?.name = nameTextField.text ?? ""
            sendToServer(stop: stop!)
        } else {
            let id = UUID().uuidString
            let stop = Stop(id: id)
            stop.name = "Belarus"
            stop.rate = 5
            stop.location = .zero
            stop.description = "Minsk"
            stop.spentMoney = spentMoney.text ?? ""
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
    
    func spent(money: Double, currency: Currency) {
        spentMoney.text = String(money) + currency.rawValue
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
