//
//  SettingsTableViewCell.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/10/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(with description: String, icon: String) {
        descriptionLabel.text = description
        iconImageView.image = UIImage(systemName: icon)
    }
    
}
