
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
        
        let travel1 = Travel(name: "Russia", description: "Moscow")
        travels.append(travel1)
        
        let travel2 = Travel(name: "Portugal", description: "Lissabon")
        travels.append(travel2)
        
        let travel3 = Travel(name: "Belarus", description: "Minsk")
        travels.append(travel3)
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
    
}
