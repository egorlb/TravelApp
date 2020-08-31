
import UIKit

// MARK: Classes

class Travel {
    var name: String
    var desctiption: String
    var stops: [Stop] = []
    
    init(name: String, description: String) {
        self.name = name
        self.desctiption = description
    }
    
    // MARK: Functions
    
    func getAvarageRating() -> Int {
        guard stops.count > 0 else { return 0 }
        
        var sum = 0
        stops.forEach { stop in
            sum += stop.rating
        }
        return sum / stops.count
    }
}
