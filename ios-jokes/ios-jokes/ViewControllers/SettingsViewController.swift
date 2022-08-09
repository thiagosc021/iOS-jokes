//
//  SettingsViewController.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/6/22.
//

import UIKit

enum Settings: CaseIterable {
    case jokeApi
    case jokeCategory
    
    func description() -> String {
        switch self {
        case .jokeApi:
            return "Jokes APIs"
        case .jokeCategory:
            return "Jokes Category"
        }
    }
    
    func icon() -> String {
        switch self {
        case .jokeApi:
            return "network"
        case .jokeCategory:
            return "server.rack"
        }
    }
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? SelectorViewController,
              let indexPathForSelectedRow = tableview.indexPathForSelectedRow else {
            return
        }
        destinationVC.settingsType = Settings.allCases[indexPathForSelectedRow.item]
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        let setting = Settings.allCases[indexPath.item]
        //cell. = UIImage(systemName: setting.icon())
        cell.textLabel?.text = setting.description()
        return cell
    }
    
}

