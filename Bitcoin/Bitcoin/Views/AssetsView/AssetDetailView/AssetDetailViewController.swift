//
//  AssetDetailViewController.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 25.02.2023.
//

import UIKit

class AssetDetailViewController: UITableViewController {
    var assetHeaderViewController: AssetHeaderViewController!
    private var spinner = UIActivityIndicatorView(style: .gray)
    static let heartAssetImageName = "heart"
    static let heartFillAssetImageName = "heart.fill"
    var viewModel: AssetViewModel?
    var watchListViewModel = WatchListViewModel()
    static let marketCapText = "Market Cap"
    static let supplyText = "Supply"
    static let volumeText = "Volume (24h)"
    
    init(viewModel: AssetViewModel) {
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
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadHeart()
    }
    
    func registerNib() {
        tableView.register(AssetDetailCell.nib, forCellReuseIdentifier: AssetDetailCell.identifier)
    }
    
    func initView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        refreshControl = UIRefreshControl()
        
        assetHeaderViewController = AssetHeaderViewController(nibName: "AssetHeaderViewController", bundle: nil)
        assetHeaderViewController?.viewModel = viewModel
        tableView.tableHeaderView = assetHeaderViewController.view
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 400)
        assetHeaderViewController?.didMove(toParent: self)
        
        spinner.transform = CGAffineTransformMakeScale(1.6, 1.6)
        tableView.tableHeaderView?.addSubview(spinner)
        spinner.frame = CGRect(x: 0, y: 150, width: UIScreen.main.bounds.width, height: 400-135)
        
        setNavigationTitle()
        reloadHeart()
    }
    
    func initViewModel() {
        fetchAssetHistoryItems(self)
        viewModel?.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
                self?.spinner.stopAnimating()
                if let tableView = self?.tableView {
                    UIView.transition(with: tableView,
                                      duration: 0.25,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        self?.assetHeaderViewController?.viewModel = self?.viewModel
                        self?.assetHeaderViewController?.addDrawing()
                        self?.assetHeaderViewController?.addHighs()
                        tableView.reloadData()
                    })
                }
            }
        }
        refreshControl?.addTarget(self, action: #selector(fetchAssetHistoryItems(_:)), for: .valueChanged)
    }
    
    @objc private func fetchAssetHistoryItems(_ sender: Any) {
        guard let assetId = viewModel?.id else { return }
        spinner.startAnimating()
        viewModel?.fetchAssetHistoryItems(with: assetId)
    }
    
    func setNavigationTitle() {
        let label = UILabel()
        let title = NSMutableAttributedString(string: viewModel!.name + " ", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)])
        title.append(NSMutableAttributedString(string: viewModel!.symbol, attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)]))
        
        label.attributedText = title
        self.navigationItem.titleView = label
    }
}
    
// MARK: - Heart & Watchlist

extension AssetDetailViewController {
    func reloadHeart() {
        let heartImage: UIImage
        if watchListViewModel.isAssetViewModelAdded(assetViewModel: viewModel!) {
            heartImage = UIImage(named: AssetDetailViewController.heartFillAssetImageName)!.withRenderingMode(.alwaysTemplate)
        } else {
            heartImage = UIImage(named: AssetDetailViewController.heartAssetImageName)!.withRenderingMode(.alwaysTemplate)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: heartImage, style: .plain, target: self, action: #selector(heartTapped))
    }
    
    @objc private func heartTapped() {
        if watchListViewModel.isAssetViewModelAdded(assetViewModel: viewModel!) {
            watchListViewModel.removeAssetViewModel(assetViewModel: viewModel!)
        } else {
            watchListViewModel.addAssetViewModel(assetViewModel: viewModel!)
        }
        reloadHeart()
    }
}

// MARK: - UITableViewDelegate

extension AssetDetailViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}

// MARK: - UITableViewDataSource

extension AssetDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetDetailCell.identifier, for: indexPath) as? AssetDetailCell else { fatalError("xib doesn't exist") }
        if indexPath.row == 0 {
            cell.viewModel = AssetDetailViewModel(name: AssetDetailViewController.marketCapText, value: viewModel?.marketCapUsd ?? "")
        }
        if indexPath.row == 1 {
            cell.viewModel = AssetDetailViewModel(name: AssetDetailViewController.supplyText, value: viewModel?.supply ?? "")
        }
        if indexPath.row == 2 {
            cell.viewModel = AssetDetailViewModel(name: AssetDetailViewController.volumeText, value: viewModel?.volumeUsd24Hr ?? "")
        }
        return cell
    }
}
