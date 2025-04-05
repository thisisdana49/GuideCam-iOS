//
//  CreateGuideViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit
import PhotosUI

final class CreateGuideViewController: BaseViewController<CreateGuideView, CreateGuideViewModel>, PHPickerViewControllerDelegate {

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func configure() {
        
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
