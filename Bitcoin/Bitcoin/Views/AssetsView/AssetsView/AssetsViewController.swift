//
//  AssetsViewController.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 24.02.2023.
//

import UIKit

class AssetsViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    private var spinner = UIActivityIndicatorView(style: .gray)
    static let alertTitle = "Error"
    static let alertMessage = "Internet Connection appears to be offline"
    static let alertOk = "OK"
    static let searchPlaceholderText = "Search"
    
    lazy var viewModel = {
        AssetsViewModel()
    }()
    
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
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = AssetsViewController.searchPlaceholderText
        searchController.searchBar.searchBarStyle = .minimal
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        spinner.transform = CGAffineTransformMakeScale(1.6, 1.6)
        tableView.backgroundView = spinner
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func initViewModel() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
                self?.spinner.stopAnimating()
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
            viewModel.fetchAssets(with: searchController.searchBar.text!, ids: nil)
            spinner.startAnimating()
        } else {
            self.refreshControl?.endRefreshing()
            let alert = UIAlertController(title: AssetsViewController.alertTitle, message: AssetsViewController.alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AssetsViewController.alertOk, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDelegate

extension AssetsViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let assetDetailViewController = storyboard.instantiateViewController(withIdentifier: "AssetDetailViewController") as! AssetDetailViewController
        assetDetailViewController.viewModel = self.viewModel.assetViewModels[indexPath.row]
        navigationController?.pushViewController(assetDetailViewController, animated: true)
    }

}

// MARK: - UITableViewDataSource

extension AssetsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.assetViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetCell.identifier, for: indexPath) as? AssetCell else { fatalError("xib doesn't exist") }
        cell.viewModel = viewModel.assetViewModels[indexPath.row]
        return cell
    }
}

// MARK: - UISearchResultsUpdating

extension AssetsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text!)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchAssets(_:)), object: nil)
        perform(#selector(fetchAssets(_:)), with: nil, afterDelay: 0.4)
    }
}
