
import UIKit

// MARK: - Classes

class Place {
    var name: String
    var description: String
    var spentMoney: Double = 0 
    var transport: Transport = .none
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}
