//
//  SelectorTableViewCell.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/8/22.
//

import UIKit

class SelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedCheckMarkImaveView: UIImageView!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    public var isItemSelected = false
    
    public func configure(with itemDescription: String, isItemSelected: Bool = true ) {
        itemDescriptionLabel.text = itemDescription
        selectedCheckMarkImaveView.isHidden = isItemSelected
        self.isItemSelected = isItemSelected
    }
    
}
