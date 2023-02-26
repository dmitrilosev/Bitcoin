//
//  SettingsViewController.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 26.02.2023.
//

import UIKit

class SettingsViewController: UITableViewController {
    var viewModel = SettingsViewModel()
    static let iconText = "Icon"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func registerNib() {
        tableView.register(SettingsCell.nib, forCellReuseIdentifier: SettingsCell.identifier)
    }
    
    func initView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as? SettingsCell else { fatalError("xib doesn't exist") }
        cell.labelText = SettingsViewController.iconText
        cell.statusText = viewModel.getIcon().name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let iconSettingsViewController = storyboard.instantiateViewController(withIdentifier: "IconSettingsViewController")
        navigationController?.pushViewController(iconSettingsViewController, animated: true)
    }
}
