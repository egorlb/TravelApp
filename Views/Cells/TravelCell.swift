import UIKit

class TravelCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var starsImageView: [UIImageView]!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewForCell: UIView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewForCell.layer.cornerRadius = 10
    }
}
