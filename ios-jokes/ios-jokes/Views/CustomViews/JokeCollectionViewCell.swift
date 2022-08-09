//
//  JokeCollectionViewCell.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/3/22.
//

import UIKit

class JokeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "joke-cell-reuse-identifier"
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var jokeLabel: UILabel!
    
    var model: Joke? {
        didSet {
            configureUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

}
private extension JokeCollectionViewCell {
    func configureUI() {
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = .orange
        
        guard let model = model else {
            return
        }
        
        jokeLabel.text = "\(model.setup) <===> \(model.punchLine)"
        
    }
}
