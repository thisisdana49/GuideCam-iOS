//
//  UIView+Extension.swift
//  GuideCam
//
//  Created by 조다은 on 4/8/25.
//

import UIKit

extension UIView {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
