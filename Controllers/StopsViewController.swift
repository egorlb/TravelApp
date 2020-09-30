
import UIKit

class StopsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateStopViewControllerDelegate {
  
    // MARK: - Outlets
    
    var travel: Travel?
//    var places: [Place] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @IBAction func addStopClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createVC = storyboard.instantiateViewController(identifier: "CreateStopViewController") as! CreateStopViewController
        createVC.delegate = self
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    // MARK: - Functions
    
    func didCreate(stop: Stop) {
        travel?.stops.append(stop)
        tableView.reloadData()
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travel?.stops.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath) as! StopCell
        if let stop = travel?.stops[indexPath.row] {
            cell.nameLabel.text = stop.name
            cell.descriptionLabel.text = stop.description
            cell.spentMoneyLabel.text = stop.spentMoney
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createVC = CreateStopViewController.fromStoryboard() as! CreateStopViewController
        createVC.delegate = self
        createVC.stop = travel?.stops[indexPath.row]
        navigationController?.pushViewController(createVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141
    }
    
}
