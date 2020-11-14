import UIKit

// MARK: Classes

class Travel {
    var userId: String
    var id: String
    var name: String
    var description: String
    var stops: [Stop] = []
    
    init(userId: String, id: String, name: String, description: String) {
        self.userId = userId
        self.id = id
        self.name = name
        self.description = description
    }
    
    var averageRate: Int {
        guard stops.count > 0 else {
            return 0
        }
        var sum = 0
        stops.forEach { (stop) in
            sum += stop.rate
        }
        return sum / stops.count
    }
    
    var json: [String: Any] {
        return ["name": name,
                "description": description,
                "stops": stops.map({ $0.json })]
    }
}

