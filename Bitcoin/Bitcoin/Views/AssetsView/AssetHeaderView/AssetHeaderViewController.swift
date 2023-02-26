//
//  AssetHeaderViewController.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 25.02.2023.
//

import Foundation
import UIKit

class AssetHeaderViewController: UIViewController {
    @IBOutlet var priceUsd: UILabel!
    @IBOutlet var changePercent24Hr: UILabel!

    var viewModel: AssetViewModel?
    
    init(viewModel: AssetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        priceUsd.text = viewModel?.priceUsd
        changePercent24Hr.text = viewModel?.changePercent24Hr
        
        addDrawing()
        addHighs()
    }
    
    func addDrawing() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createBezierPath().cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.position = CGPoint(x: 0, y: 0)
        self.view.layer.addSublayer(shapeLayer)
    }
    
    func createBezierPath() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        guard let count = viewModel?.assetHistoryItems.count, count > 0 else { return bezierPath }
        
        let minY = 180.0
        let height = 160.0
        let prices = viewModel?.assetHistoryItems.map { Double($0.priceUsd!)! }
        let maxPrice = prices!.max()!
        let minPrice = prices!.min()!
        let deltaPrice = maxPrice - minPrice
        let scale = deltaPrice / height
        let pricesScaled = viewModel?.assetHistoryItems.map { (Double($0.priceUsd!)! - minPrice) / scale }
        
        var time = 0.0
        var first = true
        let timeDelta = Double(UIScreen.main.bounds.width) / Double(prices!.count)
        pricesScaled!.forEach({ priceScaled in
            if first {
                bezierPath.move(to: CGPoint(x: time, y: minY + height - priceScaled))
                first = false
            } else {
                bezierPath.addLine(to: CGPoint(x: time, y: minY + height - priceScaled))
            }
            time += timeDelta
        })
    
        UIColor.black.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
        return bezierPath
    }
    
    func addHighs() {
        guard let count = viewModel?.assetHistoryItems.count, count > 0 else { return }
        
        let minY = 180.0
        let height = 160.0
        let prices = viewModel?.assetHistoryItems.map { Double($0.priceUsd!)! }
        let maxPrice = prices!.max()!
        let minPrice = prices!.min()!
        
        let timeDelta = Double(UIScreen.main.bounds.width) / Double(prices!.count)
        
        let maxTimePosition = Double(prices!.firstIndex(of: maxPrice)!)
        let maxLabel = UILabel(frame: CGRect(x: timeDelta * maxTimePosition, y: minY - 32, width: 100, height: 25))
        maxLabel.text = viewModel?.currencyFormatter.string(from: NSNumber(value: maxPrice))!
        maxLabel.textColor = UIColor.lightGray
        view.addSubview(maxLabel)
        
        let minTimePosition = Double(prices!.firstIndex(of: minPrice)!)
        let minLabel = UILabel(frame: CGRect(x: timeDelta * minTimePosition, y: minY + height + 5, width: 100, height: 20))
        minLabel.text = viewModel?.currencyFormatter.string(from: NSNumber(value: minPrice))!
        minLabel.textColor = UIColor.lightGray
        view.addSubview(minLabel)
    }
}
