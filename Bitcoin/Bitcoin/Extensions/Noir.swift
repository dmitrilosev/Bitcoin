//
//  Noir.swift
//  Bitcoin
//
//  Created by Dmitri Losev on 25.02.2023.
//

import UIKit

extension UIImage {
    var noir: UIImage {
            let context = CIContext(options: nil)
            let currentFilter = CIFilter(name: "CIPhotoEffectMono")!
            currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
            let output = currentFilter.outputImage!
            let cgImage = context.createCGImage(output, from: output.extent)!
            let processedImage = UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)

            return processedImage
        }
}
