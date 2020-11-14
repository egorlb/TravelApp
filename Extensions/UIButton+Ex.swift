import UIKit

extension UIButton {
    func setAnimationForButton() {
        let button = CASpringAnimation(keyPath: "opacity")
        button.duration = 0.5
        button.fromValue = 1
        button.toValue = 0.1
        button.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(button, forKey: nil)
    }
}

