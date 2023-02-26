//
//  IconSettingsViewController.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 26.02.2023.
//

import UIKit

class IconSettingsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var viewModel = SettingsViewModel()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        initView()
    }
    
    func registerNib() {
        tableView.register(IconSettingsCell.nib, forCellReuseIdentifier: IconSettingsCell.identifier)
    }
    
    func initView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        
    }
}

// MARK: - UITableViewDelegate

extension IconSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let icon = viewModel.icons[indexPath.row]
        UIApplication.shared.setAlternateIconName(icon.assetName)
        viewModel.saveIcon(icon: icon)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension IconSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IconSettingsCell.identifier, for: indexPath) as? IconSettingsCell else { fatalError("xib doesn't exist") }
        let icon = viewModel.icons[indexPath.row]
        cell.text = icon.name
        let savedIcon = DataManager.shared.getIcon()
        cell.accessoryType = (icon == savedIcon) ? .checkmark : .none
        return cell
    }
}
