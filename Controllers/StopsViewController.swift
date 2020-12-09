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
        tableView.reloadData()
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
        guard let travel = travel else { return }
        DatabaseManager.shared.saveTravelInDatabase(travel)
        tableView.reloadData()
    }
    
    func didUpdate(stop: Stop) {
        guard let travel = travel else { return }
        DatabaseManager.shared.saveTravelInDatabase(travel)
    }
   
    // MARK: - Private
    
    private func configureUI() {
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
        guard let rows = travel?.stops.count else { return 0 }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath) as! StopCell
        
        if let stop = travel?.stops[indexPath.row] {
            cell.nameLabel.text = stop.name
            cell.descriptionLabel.text = stop.description
            cell.spentMoneyLabel.text = stop.spentMoneyText
            
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
    
    private func deleteAction(stop: Stop, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Удалить",
                                      message: "Вы уверены, что хотите удалить остановку ?",
                                      preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Да", style: .default) { (action) in
            self.travel?.stops.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            TravelListViewController.removeStopFromServer(stop: stop)
            DatabaseManager.shared.deleteStop(stop)
        }

        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let stop = travel?.stops[indexPath.row] else {
            return nil
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            self.deleteAction(stop: stop, indexPath: indexPath)
            complete(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        travel?.stops.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.isEditing = editing
    }
}
