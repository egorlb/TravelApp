
import UIKit

class TravelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    var travels: [Travel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let travelCoutry = Travel(name: "Russia", description: "Moscow")
        travels.append(travelCoutry)
    }
    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelCell", for: indexPath) as! TravelCell
        cell.nameLabel.text = travels[indexPath.row].name
        cell.descriptionLabel.text = travels[indexPath.row].desctiption
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stopVC = StopsViewController.fromStoryboard() as! StopsViewController
        stopVC.travel = travels[indexPath.row]
        navigationController?.pushViewController(stopVC, animated: true)
    }
}
