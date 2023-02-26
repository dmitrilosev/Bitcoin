//
//  AssetCell.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 24.02.2023.
//

import UIKit

class AssetCell: UITableViewCell {
    @IBOutlet var assetImage: UIImageView!
    @IBOutlet var symbol: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var priceUsd: UILabel!
    @IBOutlet var changePercent24Hr: UILabel!
        
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var viewModel: AssetViewModel? {
        didSet {
            symbol.text = viewModel?.symbol
            name.text = viewModel?.name
            priceUsd.text = viewModel?.priceUsd
            changePercent24Hr.text = viewModel?.changePercent24Hr
            
            viewModel?.reloadImageView = { [weak self] in
                DispatchQueue.main.async {
                    self?.assetImage.backgroundColor = .clear
                    let image = self?.viewModel?.image
                    self?.assetImage.image = image?.noir // Noir effect
                }
            }
            viewModel?.downloadImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    func initView() {
        assetImage.layer.cornerRadius = 30
        separatorInset = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        symbol.text = nil
        name.text = nil
        priceUsd.text = nil
        changePercent24Hr.text = nil
        
        assetImage.image = nil
        viewModel?.cancelDownloadingImage()
        assetImage.backgroundColor = .lightGray
    }
}
