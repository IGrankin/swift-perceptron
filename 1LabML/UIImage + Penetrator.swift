//
//  UIImage + Penetrator.swift
//  1LabML
//
//  Created by Igor Grankin on 17/10/2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func pixelValues() -> (pixelValues: [UInt8]?, width: Int, height: Int)
    {
        let imageRef = self.cgImage
        var width = 0
        var height = 0
        var pixelValues = [UInt8]()
        if let imageRef = imageRef {
            width = imageRef.width
            height = imageRef.height
            let bitsPerComponent = imageRef.bitsPerComponent
            let bytesPerRow = imageRef.bytesPerRow
            let totalBytes = height * bytesPerRow
            
            let colorSpace = CGColorSpaceCreateDeviceGray()
            var intensities = [UInt8](repeating: 0, count: totalBytes)
            
            let contextRef = CGContext(data: &intensities, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: 0)
            contextRef?.draw(imageRef, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
            
//            pixelValues = intensities
            for  i in 0..<100 {
//                var stringText = ""
                for j in 0..<100 {
                    let pixelByte = intensities[i*416 + j] & 0xFF
                    let pixel: UInt8 = pixelByte > 0 ? 1 : 0
//                    stringText += String(format: "%i", pixel)
                    pixelValues.append(pixel)
                }
//                print(stringText)
            }
        }
        
        return (pixelValues, width, height)
    }
    
}
