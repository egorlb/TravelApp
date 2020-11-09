
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
    dynamic var transport: Transport = .none
    dynamic var currency: Currency = .none
    
    override static func primaryKey() -> String? {
          return #keyPath(RLMTravel.id)
      }
}

