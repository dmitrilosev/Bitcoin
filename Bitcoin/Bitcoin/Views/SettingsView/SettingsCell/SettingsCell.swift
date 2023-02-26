//
//  SettingsCell.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 26.02.2023.
//

import UIKit

class SettingsCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var status: UILabel!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var labelText: String? {
        didSet {
            label.text = labelText
        }
    }
    
    var statusText: String? {
        didSet {
            status.text = statusText
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        status.text = nil
    }
}
