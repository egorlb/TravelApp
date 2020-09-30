
import Foundation

extension Double {
    func rounded(_ number: Int) -> Double {
        let divisor = pow(10.0, Double(number))
        return (self * divisor).rounded() / divisor
    }
}
