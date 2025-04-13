//
//  UIView+Extension.swift
//  GuideCam
//
//  Created by 조다은 on 4/8/25.
//

import UIKit

extension UIImage {
    func withBackgroundColor(_ color: UIColor) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: self.size, format: format)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: self.size))
            self.draw(at: .zero)
        }
    }
}

extension UIView {
    func asImage() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size, format: format)
        return renderer.image { context in
            self.layer.render(in: context.cgContext)
        }
    }
}
