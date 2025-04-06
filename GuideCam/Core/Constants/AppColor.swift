//
//  AppColor.swift
//  GuideCam
//
//  Created by 조다은 on 4/6/25.
//

import UIKit

enum AppColor {
    
    enum Drawing {
        static let white = UIColor(hex: "#FFFFFF")
        static let black = UIColor(hex: "#000000")
        static let green = UIColor(hex: "#0ACD00")
        static let yellow = UIColor(hex: "#FFF71E")
        static let red = UIColor(hex: "#D60000")
        static let purple = UIColor(hex: "#E232FF")
        static let blue = UIColor(hex: "#0048FF")
        
        static let palette: [UIColor] = [
            white, black, green, yellow, red, purple, blue
        ]
    }

    enum Background {
        static let primary = UIColor(hex: "#121212")
        static let secondary = UIColor(hex: "#1E1E1E")
        static let surface = UIColor(hex: "#2A2A2A")
    }

    enum Text {
        static let primary = UIColor(hex: "#FFFFFF")
        static let secondary = UIColor(hex: "#AFAFAF")
        static let disabled = UIColor(hex: "#666666")
    }

    // 확장 가능: Button, Border, Shadow, Tag, etc.
}
