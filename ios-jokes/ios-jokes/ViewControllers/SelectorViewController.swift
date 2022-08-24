//
//  JokeAPIListViewController.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/6/22.
//

import UIKit

class SelectorViewController: UIViewController {
    private let categoryModelController = CategoryModelController.shared
    private let apiTypeModelController = ApiTypeModelController.shared
    @IBOutlet private weak var tableView: UITableView!
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
            if categoryModelController.selectedCategories.count == 1 && categoryModelController.selectedCategories[0] == category {
                cell.isItemSelected.toggle() //you need to have at least 1 category selected
                return
            }
            if cell.isItemSelected {
                categoryModelController.selectCategory(category)
                cell.selectItem()
            } else {
                categoryModelController.removeCategory(category)
                cell.unselectItem()
            }
        case .jokeApi:
            let api = APIType.allCases[indexPath.item]
            if apiTypeModelController.activeAPIList.count == 1 && apiTypeModelController.activeAPIList[0] == api {
                cell.isItemSelected.toggle() //you need to have at least 1 api selected
                return
            }
            if cell.isItemSelected {
                apiTypeModelController.selectApi(api)
                cell.selectItem()
            } else {
                apiTypeModelController.removeApi(api)
                cell.unselectItem()
            }
        default:
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
                let isSelected = categoryModelController.isSelected(category)
                cell.configure(with: category.description, iconName: category.icon, isItemSelected: isSelected)
            case .jokeApi: 
                let apiType = APIType.allCases[indexPath.item]
            let isItemSelected = apiTypeModelController.isSelected(apiType)
                cell.configure(with: apiType.description, iconName: apiType.icon, isItemSelected: isItemSelected)
            case .none: break
        }
        
        return cell
    }
}
