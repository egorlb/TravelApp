import UIKit
import Firebase
import FirebaseDatabase
import RealmSwift

class TravelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    var travelsNotification: NotificationToken!
    
    // MARK: - Variables
    
    private let nameController = "Путешествия"
    
    var travels: [Travel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTravelFromServer()
        getStopsFromServer()
        travels = DatabaseManager.shared.getTravels()
        observeTravels()
        configureUI()
        
        let travelObjects = DatabaseManager.shared.getObjects(classType: RLMTravel.self)
        let stopObjects = DatabaseManager.shared.getObjects(classType: RLMStop.self)
        let resultJson = travels.map({ $0.json })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEditing(false, animated: true)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func tappedAddButton(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Вы хотите добавить путешествие?", message: "Введите название и описание", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            let firstTextField = alertController.textFields?[0]
            let secondTextField = alertController.textFields?[1]
            if let travelName = firstTextField?.text, let travelDescription = secondTextField?.text {
                if travelName.isEmpty && travelDescription.isEmpty {
                    var message: String = ""
                    message = "Поле не заполнено"
                    
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                if let userId = Auth.auth().currentUser?.uid {
                    let id = UUID().uuidString
                    let travel = Travel(userId: userId, id: id, name: travelName, description: travelDescription)
                    self.travels.append(travel)
                    self.tableView.reloadData()
                    self.sendToServer(travel: travel)
                    DatabaseManager.shared.saveTravelInDatabase(travel)
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
    
    @objc func tappedExitButton(sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut() }
        catch {
            error.localizedDescription
        }
        let loginVC = WelcomeViewController.fromStoryboard() as! WelcomeViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    // MARK: - Functions
    
    private func configureUI() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAddButton(sender:)))
        let edit = self.editButtonItem
        let exit = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(tappedExitButton(sender:)))
        self.navigationItem.leftBarButtonItem = exit
        self.navigationItem.rightBarButtonItems = [add, edit]
        self.navigationController?.navigationBar.tintColor = UIColor(named: "purple")
        self.navigationItem.hidesBackButton = true
        self.title = nameController
        exit.tintColor = .red
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func sendToServer(travel: Travel)  {
        let database = Database.database().reference()
        let child = database.child("travels").child("\(travel.id)")
        child.setValue(travel.json) { (error, ref) in
        }
    }
    
    func getTravelFromServer() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let database = Database.database().reference()
        let ref = database.child("travels")
        let query = ref.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
        query.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self, let value = snapshot.value as? [String: Any] else {
                return
            }
            self.travels.removeAll()
            
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
        database.child("stops").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self, let value = snapshot.value as? [String: Any] else {
                return
            }
            for item in value.values {
                if let stopJson = item as? [String: Any] {
                    if let id = stopJson["id"] as? String,
                        let travelId = stopJson["travelId"] as? String {
                        let stop = Stop(id: id, travelId: travelId )
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
                        for travel in self.travels {
                            if travel.id == travelId {
                                travel.stops.append(stop)
                            }
                        }
                    }
                }
            }
            
            DatabaseManager.shared.clear()
            for travel in self.travels {
                DatabaseManager.shared.saveTravelInDatabase(travel)
            }
        }
    }
    
    func observeTravels() {
        let realm = try! Realm()
        let travels = realm.objects(RLMTravel.self)
        travelsNotification = travels.observe { (changes) in
            switch changes {
            case .initial(_):
                break
            case .update(_, let deletions, let insertions, let modifications):
                print("Did update Travels!")
            case .error(_):
                break
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
        cell.descriptionLabel.text = travel.description
        for star in 0..<travel.averageRate {
            cell.starsImageView[star].isHighlighted = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.travels.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        travels.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stopVC = StopsViewController.fromStoryboard() as! StopsViewController
        stopVC.travel = travels[indexPath.row]
        navigationController?.pushViewController(stopVC, animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.isEditing = editing
    }
}
