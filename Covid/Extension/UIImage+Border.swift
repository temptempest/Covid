//
//  UIImage+Border.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import UIKit

extension UIImage {
    func imageByAddingBorder(width: CGFloat, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: imageRect)
        let context = UIGraphicsGetCurrentContext()
        let borderRect = imageRect.insetBy(dx: width / 2, dy: width / 2)
        context?.setStrokeColor(color.cgColor)
        context?.setLineWidth(width)
        context?.stroke(borderRect)
        let borderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return borderedImage
    }
}
