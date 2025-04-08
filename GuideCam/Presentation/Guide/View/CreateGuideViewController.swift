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
        mainView.imageApplyButton.addTarget(self, action: #selector(applyImageEdit), for: .touchUpInside)
        
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
        
        mainView.imageTrashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        mainView.reselectButton.addTarget(self, action: #selector(reselectImage), for: .touchUpInside)
        mainView.eraserButton.addTarget(self, action: #selector(activateEraserMode), for: .touchUpInside)
        mainView.penButton.addTarget(self, action: #selector(activatePenMode), for: .touchUpInside)

        mainView.undoButton.addTarget(self, action: #selector(undoDrawing), for: .touchUpInside)
        mainView.redoButton.addTarget(self, action: #selector(redoDrawing), for: .touchUpInside)
        
        mainView.drawingCanvasView.onDrawingChanged = { [weak self] in
            self?.updateSaveButtonState()
        }
        
        updateSaveButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    private func updateSaveButtonState() {
        let isBlank = mainView.isCanvasEmpty()
        mainView.saveButton.isEnabled = !isBlank
        mainView.saveButton.alpha = isBlank ? 0.4 : 1.0
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
        let drawTint: UIColor = mainView.isDrawingMode ? .yellow : .white
        mainView.drawModeButton.tintColor = drawTint
        mainView.drawingToolButtons.forEach { $0.isHidden = !mainView.isDrawingMode }
        mainView.drawingCanvasView.isUserInteractionEnabled = mainView.isDrawingMode
        mainView.imageModeButton.isEnabled = !mainView.isDrawingMode
        mainView.imageModeButton.alpha = mainView.isDrawingMode ? 0.4 : 1.0
        updateSaveButtonState()
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
        updateSaveButtonState()
    }
    
    @objc private func toggleImageEditMode() {
        mainView.isImageEditMode.toggle()
        let imageTint: UIColor = mainView.isImageEditMode ? .yellow : .white
        mainView.imageModeButton.tintColor = imageTint
        mainView.isDrawingMode = false
        mainView.drawingToolButtons.forEach { $0.isHidden = true }
        mainView.drawingCanvasView.isUserInteractionEnabled = false

        // ✨ 분기 추가
        if mainView.isImageEditMode {
            if mainView.editableImageView.image == nil {
                presentImagePicker()
            } else {
                mainView.editableImageView.addImageFrameBorder() // ✅ 테두리 복구
            }
        }

        mainView.photoEditMaskView.isHidden = !mainView.isImageEditMode
        if !mainView.isImageEditMode {
            mainView.editableImageView.removeImageFrameBorder()
        }

        // 버튼, 모드 UI 처리
        mainView.imageApplyButton.isHidden = !mainView.isImageEditMode
        mainView.saveButton.isHidden = mainView.isImageEditMode
        mainView.ratioStackView.isHidden = mainView.isImageEditMode
        mainView.undoButton.isHidden = mainView.isImageEditMode
        mainView.redoButton.isHidden = mainView.isImageEditMode
//        mainView.imageDeleteButton.isHidden = !mainView.isImageEditMode
        mainView.imageTrashButton.isHidden = !mainView.isImageEditMode
        mainView.reselectButton.isHidden = !mainView.isImageEditMode
        mainView.drawModeButton.isEnabled = !mainView.isImageEditMode
        mainView.drawModeButton.alpha = mainView.isImageEditMode ? 0.4 : 1.0
        updateSaveButtonState()
    }

    @objc private func applyImageEdit() {
        toggleImageEditMode()
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
    
    @objc private func trashButtonTapped() {
        mainView.editableImageView.image = nil
        mainView.editableImageView.isHidden = true
        mainView.editableImageView.removeImageFrameBorder()
        mainView.updatePhotoEditMask()
        updateSaveButtonState()
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
                self?.mainView.editableImageView.transform = .identity
                let canvas = self?.mainView.canvasView
                let imageView = self?.mainView.editableImageView
                let size: CGFloat = 200
                let x = ((canvas?.bounds.width ?? 0) - size) / 2
                let y = ((canvas?.bounds.height ?? 0) - size) / 2
                imageView?.frame = CGRect(x: x, y: y, width: size, height: size)
                self?.mainView.editableImageView.image = image
                self?.mainView.editableImageView.removeImageFrameBorder()
                self?.mainView.editableImageView.addImageFrameBorder()
                self?.mainView.editableImageView.isHidden = false
                self?.updateSaveButtonState()
            }
        }
    }
    
    @objc private func reselectImage() {
        presentImagePicker()
    }

    @objc private func activateEraserMode() {
        mainView.drawingCanvasView.setEraserMode(true)
        mainView.drawingCanvasView.setShapeType(.free)
        mainView.penButton.isSelected = false
        mainView.shapeButton.isSelected = false
        mainView.colorButton.isSelected = false
        mainView.colorPaletteView.isHidden = true
        mainView.shapePaletteView.isHidden = true
    }

    @objc private func activatePenMode() {
        mainView.drawingCanvasView.setEraserMode(false)
        mainView.drawingCanvasView.setShapeType(.free)
        mainView.penButton.isSelected = true
        mainView.shapeButton.isSelected = false
        mainView.colorButton.isSelected = false
        mainView.colorPaletteView.isHidden = true
        mainView.shapePaletteView.isHidden = true
    }

    @objc private func undoDrawing() {
        mainView.drawingCanvasView.undo()
        updateSaveButtonState()
    }

    @objc private func redoDrawing() {
        mainView.drawingCanvasView.redo()
        updateSaveButtonState()
    }
}
