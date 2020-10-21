
import UIKit
import Firebase
import FirebaseDatabase

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
        tableView.reloadData()
        getTravelFromServer()
        getStopsFromServer()

        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    
    @IBAction func plusButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Вы хотите добавить путешествие?", message: "Введите название и описание", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            let firstTextField = alertController.textFields?[0]
            let secondTextField = alertController.textFields?[1]
            if let travelName = firstTextField?.text, let travelDescription = secondTextField?.text {
                if let userId = Auth.auth().currentUser?.uid {
                    let id = UUID().uuidString
                    let travel = Travel(userId: userId, id: id, name: travelName, description: travelDescription)
                    self.travels.append(travel)
                    self.sendToServer(travel: travel)
                    self.tableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { (action) in
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Введите назваение страны"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Введите описание"
        }
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    func sendToServer(travel: Travel)  {
        let database = Database.database().reference()
        let child = database.child("travels").child("\(travel.id)")
        child.setValue(travel.json) { (error, ref) in
        }
    }
    func getTravelFromServer() {
        let database = Database.database().reference()
        database.child("travels").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            for item in value.values {
                if let travelJson = item as? [String: Any] {
                    if let id = travelJson["id"] as? String,
                        let name = travelJson["name"] as? String,
                        let description = travelJson["description"] as? String,
                        let userId = Auth.auth().currentUser?.uid {
                        let travel = Travel(userId: userId, id: id, name: name, description: description)
                        self.travels.append(travel)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getStopsFromServer() {
        let database = Database.database().reference()
        database.child("stops").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            for item in value.values {
                if let stopJson = item as? [String: Any] {
                    if let id = stopJson["id"] as? String {
                        let stop = Stop(id: id)
                        if let name = stopJson["name"] as? String {
                            stop.name = name
                        }
                        if let description = stopJson["description"] as? String {
                            stop.description = description
                        }
                        if let spentMoney = stopJson["spentMoney"] as? String {
                            stop.spentMoney = spentMoney
                        }
                        if let rate = stopJson["rate"] as? Int {
                            stop.rate = rate
                        }
                        if let transport = stopJson["transport"] as? Int {
                            if let transport = Transport(rawValue: transport) {
                                stop.transport = transport
                            }
                        }
                        if let locationString = stopJson["location"] as? String {
                            let components = locationString.components(separatedBy: "-")
                            if let x = components.first, let y = components.last, let xCoordinate = Double(x), let yCoordinate = Double(y) {
                                stop.location = CGPoint(x: xCoordinate, y: yCoordinate)
                            }
                        }
                        if let currencyString = stopJson["currency"] as? String, let currency = Currency(rawValue: currencyString) {
                            stop.currency = currency
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelCell", for: indexPath) as! TravelCell
        let travel = travels[indexPath.row]
        cell.nameLabel.text = travel.name
        cell.descriptionLabel.text = travel.desctiption
        for star in 0..<travel.averageRate {
            cell.starsImageView[star].isHighlighted = true
        }
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
