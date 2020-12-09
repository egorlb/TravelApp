import Foundation
import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    func saveTravelInDatabase(_ travel: Travel) {
        let rlmTravel = travel.toRealm()
        let realm = try! Realm()
        try! realm.write {
            realm.add(rlmTravel, update: .all)
        }
    }
    
    func getTravels() -> [Travel] {
        var result: [Travel] = []
        let realm = try! Realm()
        let rlmTravels = realm.objects(RLMTravel.self)
        for rlmTravel in rlmTravels {
            let travel = rlmTravel.toObject()
            result.append(travel)
        }
        return result
    }
    
    func clear() {
        let realm = try! Realm()
        let rlmTravels = realm.objects(RLMTravel.self)
        let rlmStops = realm.objects(RLMStop.self)
        
        try! realm.write {
            realm.delete(rlmTravels)
            realm.delete(rlmStops)
        }
    }
    
    func deleteTravel(_ travel: Travel) {
        let realm = try! Realm()
        guard let rlmTravel = realm.object(ofType: RLMTravel.self, forPrimaryKey: travel.id) else {
            return
        }
        try! realm.write {
            realm.delete(rlmTravel)
        }
    }
    
    func deleteStop(_ stop: Stop) {
        let realm = try! Realm()
        guard let rlmStop = realm.object(ofType: RLMStop.self, forPrimaryKey: stop.id) else {
            return
        }
        try! realm.write {
            realm.delete(rlmStop)
        }
    }
    
    func getObjects<T: Object>(classType: T.Type) -> [T] {
        var result: [T] = []
        let realm = try! Realm()
        let objects = realm.objects(T.self)
        for object in objects {
            result.append(object)
        }
        return result
    }
}
