//
//  Settings.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 26.02.2023.
//

import Foundation

struct Icon: Equatable {
    var name: String
    var assetName: String
    
    static func whiteIcon() -> Icon {
        Icon(name: "White", assetName: "AppIcon-1")
    }
    static func blackIcon() -> Icon {
        Icon(name: "Black", assetName: "AppIcon-2")
    }
    static func yellowIcon() -> Icon {
        Icon(name: "Yellow", assetName: "AppIcon-3")
    }
    static func icons() -> [Icon] {
        [Icon.whiteIcon(), Icon.blackIcon(), Icon.yellowIcon()]
    }
}
