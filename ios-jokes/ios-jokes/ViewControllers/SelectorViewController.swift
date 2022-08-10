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
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
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
                let isItemSelected = Joker.shared.activeAPIList.contains(where: { $0.type == apiType })
                cell.configure(with: apiType.description, iconName: apiType.icon, isItemSelected: isItemSelected)
            case .none: break
        }
        
        return cell
    }
}
