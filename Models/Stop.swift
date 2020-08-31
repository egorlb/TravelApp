
import UIKit

// MARK: - Enums

enum Transport {
    case none, car, airplane, train
}

// MARK: - Classes

class Stop {
    var name: String
    var rating: Int = 0
    var location: CGPoint = .zero
    var spentMoney: Double = 0
    var transport: Transport = .none
    var description: String = ""
    
    init(name: String) {
        self.name = name
        
    }
}
