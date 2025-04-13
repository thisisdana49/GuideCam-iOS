//
//  DrawingCanvasView.swift
//  GuideCam
//
//  Created by 조다은 on 4/5/25.
//

import UIKit

enum DrawingShapeType {
    case free, line, circle, square, triangle
}

final class DrawingCanvasView: UIView {
    
    private var coloredPaths: [(UIBezierPath, UIColor)] = []
    private var currentPath: UIBezierPath?
    private var currentColor: UIColor = .red
    var shapeType: DrawingShapeType = .free
    private var startPoint: CGPoint?
    private var isEraserModeEnabled = false
    private var pathHistory: [[(UIBezierPath, UIColor)]] = []
    private var historyIndex: Int = -1
    var onDrawingChanged: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = false
        backgroundColor = .clear
        print(#function)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func isEmpty() -> Bool {
        return coloredPaths.isEmpty
    }
    
    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        guard let point = touches.first?.location(in: self) else { return }
        startPoint = point

        let path = UIBezierPath()
        path.lineWidth = 3.0
        path.lineCapStyle = .round
        path.move(to: point)
        currentPath = path

        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEraserModeEnabled {
            return
        }
        print(#function)
        guard let point = touches.first?.location(in: self) else { return }

        switch shapeType {
        case .free:
            currentPath?.addLine(to: point)
        case .line, .circle, .square, .triangle:
            let path = UIBezierPath()
            path.lineWidth = 3.0
            path.lineCapStyle = .round

            guard let start = startPoint else { break }

            switch shapeType {
            case .line:
                path.move(to: start)
                path.addLine(to: point)
            case .circle:
                let rect = CGRect(origin: start, size: CGSize(width: point.x - start.x, height: point.y - start.y))
                path.append(UIBezierPath(ovalIn: rect))
            case .square:
                let rect = CGRect(origin: start, size: CGSize(width: point.x - start.x, height: point.y - start.y))
                path.append(UIBezierPath(rect: rect))
            case .triangle:
                let third = CGPoint(x: start.x + (point.x - start.x) / 2, y: start.y)
                path.move(to: third)
                path.addLine(to: CGPoint(x: start.x, y: point.y))
                path.addLine(to: CGPoint(x: point.x, y: point.y))
                path.close()
            default:
                break
            }

            currentPath = path
        }
        
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        if isEraserModeEnabled, let point = touches.first?.location(in: self) {
            coloredPaths.removeAll { path, _ in
                return path.bounds.insetBy(dx: -10, dy: -10).contains(point)
            }
            setNeedsDisplay()
            return
        }
        
        guard let start = startPoint,
              let end = touches.first?.location(in: self) else {
            currentPath = nil
            return
        }

        let path = UIBezierPath()
        path.lineWidth = 3.0
        path.lineCapStyle = .round

        switch shapeType {
        case .line:
            path.move(to: start)
            path.addLine(to: end)

        case .circle:
            let rect = CGRect(origin: start, size: CGSize(width: end.x - start.x, height: end.y - start.y))
            path.append(UIBezierPath(ovalIn: rect))

        case .square:
            let rect = CGRect(origin: start, size: CGSize(width: end.x - start.x, height: end.y - start.y))
            path.append(UIBezierPath(rect: rect))

        case .triangle:
            let third = CGPoint(x: start.x + (end.x - start.x) / 2, y: start.y)
            path.move(to: third)
            path.addLine(to: CGPoint(x: start.x, y: end.y))
            path.addLine(to: CGPoint(x: end.x, y: end.y))
            path.close()

        default:
            break
        }
        
        if let finalizedPath = currentPath {
            coloredPaths.append((finalizedPath, currentColor))
            updateHistory(with: coloredPaths)
        }

        currentPath = nil
        startPoint = nil
        setNeedsDisplay()
        
        onDrawingChanged?()
    }

    // MARK: - History Management

    private func updateHistory(with paths: [(UIBezierPath, UIColor)]) {
        if historyIndex < pathHistory.count - 1 {
            pathHistory.removeSubrange((historyIndex + 1)...pathHistory.count - 1)
        }
        pathHistory.append(paths)
        historyIndex += 1
    }

    func undo() {
        guard historyIndex > 0 else { return }
        historyIndex -= 1
        coloredPaths = pathHistory[historyIndex]
        setNeedsDisplay()
    }

    func redo() {
        guard historyIndex < pathHistory.count - 1 else { return }
        historyIndex += 1
        coloredPaths = pathHistory[historyIndex]
        setNeedsDisplay()
    }

    // MARK: - Drawing

    override func draw(_ rect: CGRect) {
        if let current = currentPath {
            currentColor.setStroke()
            current.stroke()
        }
        for (path, color) in coloredPaths {
            color.setStroke()
            path.stroke()
        }
    }

    // MARK: - Public Controls

    func clear() {
        coloredPaths.removeAll()
        pathHistory.removeAll()
        historyIndex = -1
        setNeedsDisplay()
    }
    
    func setStrokeColor(_ color: UIColor) {
        currentColor = color
    }
    
    func setShapeType(_ type: DrawingShapeType) {
        shapeType = type
    }
    
    func setEraserMode(_ enabled: Bool) {
        isEraserModeEnabled = enabled
        shapeType = .free // Erase mode only available in free draw mode
    }
}
