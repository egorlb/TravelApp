
import UIKit

class StopsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateStopViewControllerDelegate {
  
    // MARK: - Variables
    
    private let nameController = "Остановка"
    var travel: Travel?

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEditing(false, animated: true)
    }
    
    // MARK: - Actions
    
    @objc func addStopClicked(sender: UIBarButtonItem) {
        let createVC = CreateStopViewController.fromStoryboard() as! CreateStopViewController
        createVC.delegate = self
        if let travel = travel?.id {
            createVC.travelId = travel
        }
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    // MARK: - Functions
    
    func didCreate(stop: Stop) {
        travel?.stops.append(stop)
        DatabaseManager.shared.saveTravelInDatabase(travel!)
        tableView.reloadData()
    }
    
    func didUpdate(stop: Stop) {
        DatabaseManager.shared.saveTravelInDatabase(travel!)
    }
    
    func configureUI() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStopClicked(sender:)))
        let edit = self.editButtonItem
        self.navigationItem.rightBarButtonItems = [add,edit]
        self.navigationController?.navigationBar.tintColor = UIColor(named: "purple")
        tableView.tableFooterView = UIView()
        self.title = nameController
        tableView.delegate = self
        tableView.dataSource = self
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
            for star in 0..<stop.rate {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.travel?.stops.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        travel?.stops.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.isEditing = editing
    }
}
