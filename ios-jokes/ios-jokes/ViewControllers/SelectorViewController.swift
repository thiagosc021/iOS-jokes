//
//  JokeAPIListViewController.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/6/22.
//

import UIKit

class SelectorViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    public var settingsType: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectorTableViewCell", bundle: nil), forCellReuseIdentifier: "selectorCell")
    }

}

extension SelectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch settingsType {
        case .jokeCategory:
            return Category.allCases.count
        case .jokeApi:
            return APIType.allCases.count
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectorCell", for: indexPath) as? SelectorTableViewCell else {
            return UITableViewCell()
        }
        
        switch settingsType {
            case .jokeCategory:
                let category = Category.allCases[indexPath.item]                
                cell.configure(with: category.description())
            case .jokeApi: 
                let apiType = APIType.allCases[indexPath.item]
                let isItemSelected = Joker.shared.activeAPIList.contains(where: { $0.type == apiType })
                cell.configure(with: apiType.description(), isItemSelected: isItemSelected)
            case .none: break
        }
        
        return cell
    }
}
