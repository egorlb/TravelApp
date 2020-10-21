
import UIKit

class StopCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var spentMoneyLabel: UILabel!
    @IBOutlet weak var transportImage: UIImageView!
    @IBOutlet weak var viewForCell: UIView!
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewForCell.layer.cornerRadius = 25
    }
}
