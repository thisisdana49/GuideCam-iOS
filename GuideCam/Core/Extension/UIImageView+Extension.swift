//
//  UIImageView+Extension.swift
//  GuideCam
//
//  Created by 조다은 on 4/7/25.
//

import UIKit

extension UIImageView {
    func addImageFrameBorder(color: UIColor = .yellow, lineWidth: CGFloat = 2) {
        // 기존 border 레이어 제거
        layer.sublayers?.filter { $0.name == "ImageFrameBorder" }.forEach { $0.removeFromSuperlayer() }
        
        guard let image = image else { return }

        // 실제 이미지 표시 영역 계산
        let imageSize = image.size
        let imageViewSize = bounds.size

        let scale = min(imageViewSize.width / imageSize.width,
                        imageViewSize.height / imageSize.height)

        let width = imageSize.width * scale
        let height = imageSize.height * scale
        let x = (imageViewSize.width - width) / 2
        let y = (imageViewSize.height - height) / 2

        let borderFrame = CGRect(x: x, y: y, width: width, height: height)
        let borderPath = UIBezierPath(rect: borderFrame)

        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "ImageFrameBorder"
        shapeLayer.path = borderPath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth

        layer.addSublayer(shapeLayer)
    }
    
    func removeImageFrameBorder() {
        layer.sublayers?.filter { $0.name == "ImageFrameBorder" }.forEach { $0.removeFromSuperlayer() }
    }
}
