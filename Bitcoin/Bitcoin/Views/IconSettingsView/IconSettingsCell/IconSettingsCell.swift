//
//  IconSettingsCell.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 26.02.2023.
//

import UIKit

class IconSettingsCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        accessoryType = .none
    }
}
