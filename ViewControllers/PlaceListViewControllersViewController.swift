
import UIKit

class PlaceListViewControllersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    var places: [Place] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let firstPlace = Place(name: "Москва", description: "Вылетели в 12 из Шереметьево")
        places.append(firstPlace)
        
        let secondPlace = Place(name: "Рим", description: "Прилетели в Рим в 16:00 по местному ")
        places.append(firstPlace)
        
        let thirdPlace = Place(name: "Неаполь", description: "На электричке до Неаполя")
        places.append(firstPlace)
        
        let forthPlace = Place(name: "Кастелабатте", description: "На машине до Кастелабатте")
        places.append(firstPlace)
        
        
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        cell.descriptionLabel.text = place.description
        cell.spentMoneyLabel.text = "€850"
        cell.transportImage.image = UIImage(named: "Car")
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141
    }
}
