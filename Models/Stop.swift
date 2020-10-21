
import UIKit

// MARK: - Enums

enum Transport: Int {
    case none, car, airplane, train
}

// MARK: - Classes

class Stop {
    var id: String
    var name: String = ""
    var spentMoney = ""
    var rate: Int = 0
    var location: CGPoint = .zero
    var transport: Transport = .none
    var description: String = ""
    var currency: Currency = .none
    
    init(id: String) {
        self.id = id
    }
    
    var json: [String: Any] {
        return ["id": id,
                "name": name,
                "rate": rate,
                "spentMoney": spentMoney,
                "location": "\(location.x)-\(location.y)",
                "transport": transport.rawValue,
                "currency": currency.rawValue]
    }
}
