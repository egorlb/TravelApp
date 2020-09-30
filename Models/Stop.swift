
import UIKit

// MARK: - Enums

enum Transport {
    case none, car, airplane, train
}

// MARK: - Classes

class Stop {
    var name: String = ""
    var spentMoney = ""
    var rating: Int = 0
    var location: CGPoint = .zero
    var transport: Transport = .none
    var description: String = ""
}
