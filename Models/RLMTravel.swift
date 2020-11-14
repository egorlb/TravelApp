import Foundation
import RealmSwift

class RLMTravel: Object {
    @objc dynamic var userId: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    let stops = List<RLMStop>()
    
    override static func primaryKey() -> String? {
        return #keyPath(RLMTravel.id)
    }
}

