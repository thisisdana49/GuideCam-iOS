//
//  DrawingCanvasView.swift
//  GuideCam
//
//  Created by 조다은 on 4/5/25.
//

import UIKit

final class DrawingCanvasView: UIView {
    
    private var coloredPaths: [(UIBezierPath, UIColor)] = []
    private var currentPath: UIBezierPath?
    private var currentColor: UIColor = .red

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = false
        backgroundColor = .gray
        print(#function)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        guard let point = touches.first?.location(in: self) else { return }

        let path = UIBezierPath()
        path.lineWidth = 3.0
        path.lineCapStyle = .round
        path.move(to: point)

        currentPath = path
        coloredPaths.append((path, currentColor))

        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        guard let point = touches.first?.location(in: self),
              let path = currentPath else { return }

        path.addLine(to: point)
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        currentPath = nil
    }

    // MARK: - Drawing

    override func draw(_ rect: CGRect) {
        for (path, color) in coloredPaths {
            color.setStroke()
            path.stroke()
        }
    }

    // MARK: - Public Controls

    func clear() {
        coloredPaths.removeAll()
        setNeedsDisplay()
    }
    
    func setStrokeColor(_ color: UIColor) {
        currentColor = color
    }
}
