//
//  JokeCollectionViewCell.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/3/22.
//

import UIKit

protocol JokeCollectionViewCellDelegate {
    func favoriteTapped(joke: Joke, isFavorite: Bool)
    func blockTapped(joke: Joke, isBlocked: Bool)
}

enum ButtonType {
    case favorite(selected: Bool)
    case block(selected: Bool)
    
    var imageName: String {
        switch self {
        case .favorite(let selected):
            return selected ? "heart.fill" : "heart"
        case .block(let selected):
            return selected ? "hand.thumbsdown.fill" : "hand.thumbsdown"
        }
    }
}

class JokeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "joke-cell-reuse-identifier"
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var jokeLabel: UILabel!
    @IBOutlet private weak var punchLineLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var blockButton: UIButton!
    private var isFavorite = false
    private var isBlocked = false
    
    var delegate: JokeCollectionViewCellDelegate?
    var model: Joke?
    {
        didSet {
            configureUI()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureUI()
    }
    
    public func togglePunchLine() {
        if model?.style == .Daddys {
            DispatchQueue.main.async {
                UIView.transition(with: self.punchLineLabel, duration: 0.6,
                                options: .transitionCrossDissolve,
                                animations: {
                                    self.punchLineLabel.isHidden.toggle()
                            })
            }
        }
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let model = model else {
            return
        }
        isFavorite.toggle()
        blockButton.isEnabled = !isFavorite
        toggleButton(with: .favorite(selected: isFavorite), model: model)
        delegate?.favoriteTapped(joke: model, isFavorite: isFavorite)
    }
    
    @IBAction func blockButtonTapped(_ sender: Any) {
        guard let model = model else {
            return
        }
        isBlocked.toggle()
        favoriteButton.isEnabled = !isBlocked
        toggleButton(with: .block(selected: isBlocked), model: model)
        delegate?.blockTapped(joke: model, isBlocked: isBlocked)
    }
}
private extension JokeCollectionViewCell {
    func configureUI() {
        punchLineLabel.isHidden = true
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 3
        
        guard let model = model else {
            return
        }
        
        let font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        if model.style == .Daddys {
            let punchLineColor = UIColor.gray
            let punchLineAttributes:[NSAttributedString.Key: Any] = [.font: font, .foregroundColor: punchLineColor]
            let attributedPunchLine = NSAttributedString(string: model.punchLine, attributes: punchLineAttributes)
            punchLineLabel.attributedText = attributedPunchLine
        }
                
        let color = UIColor.white
        let setupAttributes:[NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let attributedSetup = NSAttributedString(string: model.setup, attributes: setupAttributes)
        jokeLabel.attributedText = attributedSetup
        isFavorite = model.isFavorite
        isBlocked = model.isBlocked
        configureFavoriteButton()
        configureBlockButton()
    }
    
    func toggleButton(with type: ButtonType, model: Joke) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        let imageName = type.imageName
        let image = UIImage(systemName: imageName, withConfiguration: largeConfig)
        switch type {
        case .favorite(_):
            favoriteButton.setImage(image, for: .normal)
            favoriteButton.tintColor = .red
        case .block(_):
            blockButton.setImage(image, for: .normal)
            blockButton.tintColor = .black
        }
    }
    
    func configureFavoriteButton() {
        guard let model = model else {
            return
        }
        favoriteButton.isEnabled = !model.isBlocked
        toggleButton(with: .favorite(selected: model.isFavorite), model: model)
    }
    
    func configureBlockButton() {
        guard let model = model else {
            return
        }
        blockButton.isEnabled = !model.isFavorite
        toggleButton(with: .block(selected: model.isBlocked), model: model)
    }
    
    func configureGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemCyan.cgColor]
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
