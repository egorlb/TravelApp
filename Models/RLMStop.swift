import Foundation
import RealmSwift

class RLMStop: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var travelId: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var spentMoney: String = ""
    @objc dynamic var rate: Int = 0
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var transportInt: Int = 0
    @objc dynamic var currencyString: String = ""
    
    var transport: Transport {
        get {
            return Transport(rawValue: transportInt)!
        }
        set {
            transportInt = newValue.rawValue
        }
    }
    
    var currency: Currency {
        get {
            return Currency(rawValue: currencyString)!
        }
        set {
            currencyString = newValue.rawValue
        }
    }
    
    // MARK: - Static
    
    override static func primaryKey() -> String? {
        return #keyPath(RLMStop.id)
    }
}

