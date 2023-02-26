//
//  SettingsViewModel.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 26.02.2023.
//

import UIKit

protocol SettingsViewModelProtocol {
    var icons: [Icon] { get }
    func getIcon() -> Icon
    func saveIcon(icon: Icon)
}

class SettingsViewModel: SettingsViewModelProtocol {
    var icons = Icon.icons()
    
    func getIcon() -> Icon {
        DataManager.shared.getIcon()
    }
    
    func saveIcon(icon: Icon) {
        DataManager.shared.setIcon(icon: icon)
    }
}

