
import UIKit

// MARK: - Enums

enum Transport: Int {
    case none, car, airplane, train
}

// MARK: - Classes

class Stop {
    var id: String
    var travelId: String
    var name: String = ""
    var spentMoney = ""
    var rate: Int = 0
    var location: CGPoint = .zero
    var transport: Transport = .none
    var description: String = ""
    var currency: Currency = .none
    
    init(id: String, travelId: String) {
        self.id = id
        self.travelId = travelId
    }
    
    var json: [String: Any] {
        return ["id": id,
                "travelId": travelId,
                "name": name,
                "rate": rate,
                "spentMoney": spentMoney,
                "location": "\(location.x)-\(location.y)",
                "transport": transport.rawValue,
                "currency": currency.rawValue]
    }
}
