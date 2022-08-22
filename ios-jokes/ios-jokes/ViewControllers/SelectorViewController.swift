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
        tableView.delegate = self
        tableView.register(UINib(nibName: "SelectorTableViewCell", bundle: nil), forCellReuseIdentifier: "selectorCell")
    }

}

extension SelectorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectorTableViewCell else {
            return
        }
        cell.isItemSelected.toggle()
        switch settingsType {
        case .jokeCategory:
            let category = Category.allCases[indexPath.item]
            if ChuckNorrisAPI.shared.selectedCategories.count == 1 && ChuckNorrisAPI.shared.selectedCategories[0] == category {
                cell.isItemSelected.toggle() //you need to have at least 1 category selected
                return
            }
            if cell.isItemSelected {
                ChuckNorrisAPI.shared.selectedCategories.append(category)
            } else {
                ChuckNorrisAPI.shared.selectedCategories.removeAll(where: { $0 == category })
            }
        case .jokeApi:
            let api = APIType.allCases[indexPath.item]
            if Joker.shared.activeAPIList.count == 1 && Joker.shared.activeAPIList[0] == api {
                cell.isItemSelected.toggle() //you need to have at least 1 api selected
                return
            }
            if cell.isItemSelected {
                Joker.shared.activeAPIList.append(api)
            } else {
                Joker.shared.activeAPIList.removeAll(where: { $0 == api })
            }
        case .none:
            return
        
        }
        
        
        
    }
    
}

extension SelectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
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
                cell.configure(with: category.description, iconName: category.icon)
            case .jokeApi: 
                let apiType = APIType.allCases[indexPath.item]
                let isItemSelected = Joker.shared.activeAPIList.contains(where: { $0 == apiType })
                cell.configure(with: apiType.description, iconName: apiType.icon, isItemSelected: isItemSelected)
            case .none: break
        }
        
        return cell
    }
}
