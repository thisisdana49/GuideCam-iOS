//  CreateGuideViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit
import PhotosUI

final class CreateGuideViewController: BaseViewController<CreateGuideView, CreateGuideViewModel>, PHPickerViewControllerDelegate {

    private var selectedShape: ShapeType = .line
    
    enum ShapeType {
        case line, circle, square, triangle
    }

    weak var coordinator: GuideListCoordinating?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function, self)
        navigationController?.setNavigationBarHidden(true, animated: false)
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        mainView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        mainView.drawModeButton.addTarget(self, action: #selector(toggleDrawingMode), for: .touchUpInside)
        mainView.imageModeButton.addTarget(self, action: #selector(toggleImageEditMode), for: .touchUpInside)
        
        // 제스처 등록
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))

        mainView.editableImageView.addGestureRecognizer(pinch)
        mainView.editableImageView.addGestureRecognizer(rotate)
        mainView.editableImageView.addGestureRecognizer(pan)

        mainView.colorButton.addTarget(self, action: #selector(toggleColorPalette), for: .touchUpInside)
        
        for case let button as UIButton in mainView.colorPaletteView.arrangedSubviews {
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
        }
        
        mainView.shapeButton.addTarget(self, action: #selector(toggleShapePalette), for: .touchUpInside)

        for (index, view) in mainView.shapePaletteView.arrangedSubviews.enumerated() {
            if let button = view as? UIButton {
                button.tag = index
                button.addTarget(self, action: #selector(shapeButtonTapped(_:)), for: .touchUpInside)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func configure() {
        mainView.colorPaletteView.axis = .horizontal
        mainView.colorPaletteView.spacing = 8
        mainView.colorPaletteView.alignment = .center
        mainView.colorPaletteView.isHidden = true
        
        mainView.colorPaletteView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let colors: [UIColor] = AppColor.Drawing.palette
        
        colors.forEach { color in
            let button = UIButton()
            button.backgroundColor = color
            button.layer.cornerRadius = 16
            button.clipsToBounds = true
            mainView.colorPaletteView.addArrangedSubview(button)
        }
    }
    
    override func bind() {
        super.bind()
        
        for button in mainView.ratioButtons {
            button.addTarget(self, action: #selector(ratioButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    private func presentImagePicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func ratioButtonTapped(_ sender: UIButton) {
        print(#function)
        guard let ratio = sender.titleLabel?.text else { return }
        
        // Save absolute center position in screen coordinates
        let globalCenter = mainView.editableImageView.superview?.convert(mainView.editableImageView.center, to: nil)
        let savedTransform = mainView.editableImageView.transform

        mainView.setSelectedRatio(ratio)
        
        mainView.layoutIfNeeded()

        // Restore center using global to local conversion
        if let global = globalCenter {
            let local = mainView.canvasView.convert(global, from: nil)
            mainView.editableImageView.center = local
        }
        mainView.editableImageView.transform = savedTransform
    }
    
    @objc private func backButtonTapped() {
        coordinator?.didFinishCreateGuide()
    }
    
    @objc private func saveButtonTapped() {
        coordinator?.showSaveConfirm()
    }
    
    @objc private func toggleDrawingMode() {
        print(#function)
        mainView.isDrawingMode.toggle()
        mainView.drawingToolButtons.forEach { $0.isHidden = !mainView.isDrawingMode }
    }
    
    @objc private func toggleColorPalette() {
        print(#function)
        mainView.colorPaletteView.isHidden.toggle()
    }
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        let color = sender.backgroundColor ?? .red
        mainView.selectedColor = color
        mainView.drawingCanvasView.setStrokeColor(color)
        mainView.colorPaletteView.isHidden = true
    }
    
    @objc private func toggleImageEditMode() {
        print(#function)
        mainView.isImageEditMode.toggle()
        mainView.isDrawingMode = false
        mainView.drawingToolButtons.forEach { $0.isHidden = true }
        
        if mainView.isImageEditMode {
            presentImagePicker()
        }
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }

    @objc private func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: view.superview)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gesture.setTranslation(.zero, in: view.superview)
    }
    
    @objc private func toggleShapePalette() {
        mainView.shapePaletteView.isHidden.toggle()
    }

    @objc private func shapeButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            selectedShape = .line
            mainView.drawingCanvasView.setShapeType(.line)
        case 1:
            selectedShape = .circle
            mainView.drawingCanvasView.setShapeType(.circle)
        case 2:
            selectedShape = .square
            mainView.drawingCanvasView.setShapeType(.square)
        case 3:
            selectedShape = .triangle
            mainView.drawingCanvasView.setShapeType(.triangle)
        default: break
        }

        mainView.shapePaletteView.isHidden = true
        print("Selected shape:", selectedShape)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }

        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let image = object as? UIImage else { return }
            DispatchQueue.main.async {
                let canvas = self?.mainView.canvasView
                let imageView = self?.mainView.editableImageView
                let size: CGFloat = 200
                let x = ((canvas?.bounds.width ?? 0) - size) / 2
                let y = ((canvas?.bounds.height ?? 0) - size) / 2
                imageView?.frame = CGRect(x: x, y: y, width: size, height: size)
                self?.mainView.editableImageView.image = image
                self?.mainView.editableImageView.isHidden = false
            }
        }
    }
    
}
