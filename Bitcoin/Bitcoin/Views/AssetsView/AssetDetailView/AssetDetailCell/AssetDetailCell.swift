//
//  AssetDetailCell.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 25.02.2023.
//

import UIKit

class AssetDetailCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var value: UILabel!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var viewModel: AssetDetailViewModel? {
        didSet {
            name.text = viewModel?.name
            value.text = viewModel?.formattedValue
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        value.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
