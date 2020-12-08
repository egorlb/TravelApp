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
        try? Auth.auth().signOut()
        
        var rootController: UIViewController? = nil
        if let navigationController = navigationController {
            for viewcontroller in navigationController.viewControllers {
                if viewcontroller is WelcomeViewController {
                    rootController = viewcontroller
                }
            }
            if let rootController = rootController {
                self.navigationController?.popToViewController(rootController, animated: false)
            } else {
                let welcomeVC  = WelcomeViewController.fromStoryboard() as! WelcomeViewController
                navigationController.setViewControllers([welcomeVC], animated: false)
            }
        }
        DatabaseManager.shared.clear()
    }
    
    // MARK: - Public
    
    func sendToServer(travel: Travel)  {
        let database = Database.database().reference()
        let child = database.child("travels").child("\(travel.id)")
        child.setValue(travel.json) { (error, ref) in
        }
    }
    
    func removeTravelFromServer(travel: Travel) {
        let database = Database.database().reference()
        let child = database.child("travels").child("\(travel.id)")
        child.removeValue()
    }
    
    static func removeStopFromServer(stop: Stop) {
        let database = Database.database().reference()
        let child = database.child("stops").child("\(stop.id)")
        child.removeValue()
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
    
    // MARK: - Private
    
    private func configureUI() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAddButton(sender:)))
        let edit = self.editButtonItem
        let signOut = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(tappedExitButton(sender:)))
        self.navigationItem.leftBarButtonItem = signOut
        self.navigationItem.rightBarButtonItems = [add, edit]
        self.navigationController?.navigationBar.tintColor = UIColor(named: "purple")
        self.navigationItem.hidesBackButton = true
        self.title = nameController
        signOut.tintColor = .red
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    private func updateAction(travel: Travel, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Обновить",
                                      message: "Обновить путешествие",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            guard let textField = alert.textFields?.first else {
                return
            }
            if let textToEdit = textField.text {
                if textToEdit.count == 0 {
                    return
                }
                travel.name = textToEdit
                self.tableView.reloadRows(at: [indexPath], with: .fade)
                self.sendToServer(travel: travel)
                DatabaseManager.shared.saveTravelInDatabase(travel)
            } else {
                return
            }
        }
        
        let cancelAction = UIAlertAction(title: "Нет", style: .default)
        alert.addTextField()
        guard let textField = alert.textFields?.first else {
            return
        }
        textField.placeholder = "Измените название путешествия"
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func deleteAction(travel: Travel, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Удалить",
                                      message: "Вы уверены, что хотите удалить путешествие ?",
                                      preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Да", style: .default) { (action) in
            let travel = self.travels[indexPath.row]
            self.travels.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.removeTravelFromServer(travel: travel)
            DatabaseManager.shared.deleteTravel(travel)
        }
        
        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
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
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let travel = travels[indexPath.row]
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.updateAction(travel: travel, indexPath: indexPath)
        }
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.deleteAction(travel: travel, indexPath: indexPath)
        }
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = .blue
        return [deleteAction, editAction]
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
