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
    
    var description: String {
        switch self {
        case .jokeApi:
            return "Jokes APIs"
        case .jokeCategory:
            return "Jokes Category"
        }
    }
    
    var icon: String {
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
        tableview.delegate = self
        tableview.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? SelectorViewController,
              let indexPathForSelectedRow = tableview.indexPathForSelectedRow else {
            return
        }
        destinationVC.settingsType = Settings.allCases[indexPathForSelectedRow.item]
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "settingsToSelectorSegue", sender: indexPath.row)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        let setting = Settings.allCases[indexPath.item]
        cell.configure(with: setting.description, icon: setting.icon)
        return cell
    }
    
}

