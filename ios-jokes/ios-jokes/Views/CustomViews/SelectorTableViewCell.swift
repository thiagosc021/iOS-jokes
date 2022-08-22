//
//  SelectorTableViewCell.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/8/22.
//

import UIKit

class SelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var selectedCheckMarkImaveView: UIImageView!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    public var toggleSelection: (() -> Void)?
    public var isItemSelected = true {
        didSet {
            self.selectedCheckMarkImaveView.isHidden.toggle()
        }
    }
    
    public func configure(with itemDescription: String, iconName: String, isItemSelected: Bool = true ) {
        itemDescriptionLabel.text = itemDescription
        selectedCheckMarkImaveView.isHidden = !isItemSelected
        iconImageView.image = UIImage(systemName: iconName)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
}
