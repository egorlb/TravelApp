
import UIKit

class StopsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateStopViewControllerDelegate {
  
    // MARK: - Outlets
    
    var travel: Travel?
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        setupPropertiesForNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @objc func addStopClicked(sender: UIBarButtonItem) {
        let createVC = CreateStopViewController.fromStoryboard() as! CreateStopViewController
        createVC.delegate = self
        createVC.travelId = travel?.id ?? ""
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    // MARK: - Functions
    
    func didCreate(stop: Stop) {
        travel?.stops.append(stop)
        tableView.reloadData()
    }
    
    func setupPropertiesForNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStopClicked(sender:)))
        self.navigationController?.navigationBar.tintColor = UIColor(named: "purple")
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
            
            if stop.transport == .airplane {
                cell.transportImage.image = #imageLiteral(resourceName: "Airplane")
            } else if stop.transport == .train {
                cell.transportImage.image = #imageLiteral(resourceName: "Train")
            } else if stop.transport == .car {
                cell.transportImage.image = #imageLiteral(resourceName: "Car")
            }
        }
        
        if let travel = travel?.averageRate {
            for star in 0..<travel {
                cell.starsImageView[star].isHighlighted = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createVC = CreateStopViewController.fromStoryboard() as! CreateStopViewController
        createVC.delegate = self
        createVC.stop = travel?.stops[indexPath.row]
        createVC.travelId = travel?.id ?? ""
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141
    }
}
