//
//  ViewController.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/1/22.
//

import UIKit

enum Section {
    case main
}

class HomeViewController: UIViewController {
    private var collectionView: UICollectionView! = nil
    private let joker = Joker.shared
    private lazy var dataSource = configureDataSource()
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNotificationConsumers()
        if joker.fetchLocal() {
            loadSnapshot()
        } else {
            joker.fetchJokes(max: 10)
        }
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            joker.applyFilter(.all)
        case 1:
            joker.applyFilter(.favorited)
        case 2:
            joker.applyFilter(.blocked)
        default:
            break
        }
        loadSnapshot()
    }
    var currentIndex = 0
}

private extension HomeViewController {
    @objc
    func loadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Joke>()
        snapshot.appendSections([.main])
        snapshot.appendItems(joker.jokesList)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.anchor(top: self.view.topAnchor,
                              bottom: self.view.bottomAnchor,
                              leading: self.view.leadingAnchor,
                              trailing: self.view.trailingAnchor,
                              paddingTop: 150.0,
                              paddingBottom: 25.0,
                              paddingLeft: 10.0,
                              paddingRight: 10.0)
        collectionView.layer.cornerRadius = 12
        collectionView.register(UINib(nibName: "JokeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: JokeCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
    }
    
    func configureNotificationConsumers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadSnapshot),
                                               name: .jokeDidAdd,
                                               object: nil)      
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(section: generateEventSectionLayout())
        return layout
    }
    
    func generateEventSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 3,
                                                     leading: 20,
                                                     bottom: 3,
                                                     trailing: 20)
        
        let itemGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.2))
        let itemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: itemGroupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: itemGroup)
        section.orthogonalScrollingBehavior = .groupPaging        
        return section
    }
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section,Joke>{
        let dataSource = UICollectionViewDiffableDataSource<Section, Joke>(collectionView: collectionView) { (collectionView, indexPath, joke) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JokeCollectionViewCell.reuseIdentifier, for: indexPath) as? JokeCollectionViewCell else {
                fatalError("Could not create view cell")
            }
            
            cell.model = joke
            cell.delegate = self
            return cell
        }
        return dataSource
    }
}


extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? JokeCollectionViewCell else {
            return
        }
        cell.togglePunchLine()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        joker.preFetchJokesIfNeeded(currentIndex: indexPath.item)
    }
}

extension HomeViewController: JokeCollectionViewCellDelegate {
    func favoriteTapped(joke: Joke, isFavorite: Bool) {
        self.joker.favorite(joke, isFavorite: isFavorite)
    }
    
    func blockTapped(joke: Joke, isBlocked: Bool) {
        self.joker.block(joke, isBlocked: isBlocked)
    }
}
