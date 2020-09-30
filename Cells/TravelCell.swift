//
//  TravelCell.swift
//  TravelApp
//
//  Created by Egor on 27/08/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class TravelCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewForCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewForCell.layer.cornerRadius = 10
    }
}
