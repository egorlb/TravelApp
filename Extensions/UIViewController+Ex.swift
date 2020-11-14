import UIKit

extension UIViewController {
    static func fromStoryboard() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
