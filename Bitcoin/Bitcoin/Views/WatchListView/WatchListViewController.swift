//
//  WatchListViewController.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 26.02.2023.
//

import UIKit

class WatchListViewController: UITableViewController {
    var watchListViewModel = WatchListViewModel()
    var assetsViewModel = AssetsViewModel()
    static let alertTitle = "Error"
    static let alertMessage = "Internet Connection appears to be offline"
    static let alertOk = "OK"
    static let emptyTitle = "No assets yet\n"
    static let emptyMessage = "Your Watchlist will appear here"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        initView()
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAssets(self)
    }
    
    func registerNib() {
        tableView.register(AssetCell.nib, forCellReuseIdentifier: AssetCell.identifier)
    }
    
    func initView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        refreshControl = UIRefreshControl()
    }
    
    func initViewModel() {
        assetsViewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
                if let tableView = self?.tableView {
                    UIView.transition(with: tableView,
                                      duration: 0.25,
                                      options: .transitionCrossDissolve,
                                      animations: { tableView.reloadData() })
                }
            }
        }
        refreshControl?.addTarget(self, action: #selector(fetchAssets(_:)), for: .valueChanged)
    }
    
    @objc private func fetchAssets(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            let ids = watchListViewModel.getAssetIds()
            assetsViewModel.fetchAssets(with: "", ids: ids)
        } else {
            self.refreshControl?.endRefreshing()
            let alert = UIAlertController(title: WatchListViewController.alertTitle, message: WatchListViewController.alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: WatchListViewController.alertOk, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDelegate

extension WatchListViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let assetDetailViewController = storyboard.instantiateViewController(withIdentifier: "AssetDetailViewController") as! AssetDetailViewController
        assetDetailViewController.viewModel = assetsViewModel.assetViewModels[indexPath.row]
        navigationController?.pushViewController(assetDetailViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension WatchListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ids = watchListViewModel.getAssetIds()
        if !ids.isEmpty {
            // Watchlist
            removeEmptyMessage()
            return assetsViewModel.assetViewModels.count
        } else {
            // Empty
            setEmptyMessage()
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetCell.identifier, for: indexPath) as? AssetCell else { fatalError("xib doesn't exist") }
        cell.viewModel = assetsViewModel.assetViewModels[indexPath.row]
        return cell
    }
}

// MARK: - Editing

extension WatchListViewController {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let assetViewModel = assetsViewModel.assetViewModels[indexPath.row]
            watchListViewModel.removeAssetViewModel(assetViewModel: assetViewModel)
            assetsViewModel.assetViewModels.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
}

// MARK: - Empty Watchlist

extension WatchListViewController {
    func setEmptyMessage() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        let title = NSMutableAttributedString(string: WatchListViewController.emptyTitle, attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)])
        
        title.append(NSMutableAttributedString(string: WatchListViewController.emptyMessage, attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.regular)]))
        
        label.attributedText = title
        label.textAlignment = .center
        label.numberOfLines = 2
        label.sizeToFit()
        
        tableView.backgroundView = label
        tableView.separatorStyle = .none
    }

    func removeEmptyMessage() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
}
