//  CreateGuideView.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit
import SnapKit

final class CreateGuideView: BaseView {

    let ratioStackView = UIStackView()
    let backButton = UIButton()
    let saveButton = UIButton()
    let canvasView = UIView()
    let editableImageView = UIImageView()
    
    let drawingCanvasView = DrawingCanvasView() // Added DrawingCanvasView

    let drawModeButton = UIButton()
    let imageModeButton = UIButton()
    let undoButton = UIButton()
    let redoButton = UIButton()
    
    let penButton = UIButton()
    let eraserButton = UIButton()
    let shapeButton = UIButton()
    let colorButton = UIButton()
    
    let drawingStackView = UIStackView()
    
    var selectedRatio: String = "9:16"
    var ratioButtons: [UIButton] = []
    var drawingToolButtons: [UIButton] = []
    var canvasHeightConstraint: Constraint?
    var isDrawingMode: Bool = false
    var isImageEditMode: Bool = false
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(canvasView)
        addSubview(drawingStackView)
        addSubview(undoButton)
        addSubview(redoButton)
        addSubview(backButton)
        addSubview(ratioStackView)
        addSubview(saveButton)
        
        drawingStackView.addArrangedSubview(drawModeButton)
        drawingStackView.addArrangedSubview(penButton)
        drawingStackView.addArrangedSubview(eraserButton)
        drawingStackView.addArrangedSubview(shapeButton)
        drawingStackView.addArrangedSubview(colorButton)
        drawingStackView.addArrangedSubview(imageModeButton)
        
        canvasView.addSubview(editableImageView)
        canvasView.addSubview(drawingCanvasView)
    }

    override func configureLayout() {
        canvasView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            canvasHeightConstraint = make.height.equalTo(500).constraint
        }

        ratioStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalTo(ratioStackView)
            $0.width.height.equalTo(32)
        }

        saveButton.snp.remakeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(ratioStackView)
            $0.width.equalTo(64)
            $0.height.equalTo(32)
        }

        drawingStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }

        redoButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(drawingStackView)
            $0.width.height.equalTo(40)
        }

        undoButton.snp.makeConstraints {
            $0.trailing.equalTo(redoButton.snp.leading).offset(-16)
            $0.centerY.equalTo(redoButton)
            $0.width.height.equalTo(40)
        }
        
        drawingCanvasView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = .black

        canvasView.backgroundColor = .white
        canvasView.clipsToBounds = true
        
        editableImageView.contentMode = .scaleAspectFit
        editableImageView.isHidden = true
        editableImageView.isUserInteractionEnabled = true
        
        // 비율 스택 뷰 설정
        ratioStackView.axis = .horizontal
        ratioStackView.spacing = 8
        ratioStackView.alignment = .center

        let ratios = ["1:1", "3:4", "9:16"]
        ratios.forEach { ratio in
            let button = UIButton()
            button.setTitle(ratio, for: .normal)
            button.setTitleColor(.yellow, for: .selected)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .darkGray
            button.layer.cornerRadius = 16
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            ratioStackView.addArrangedSubview(button)
            ratioButtons.append(button)
        }

        // 상단 저장 버튼
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white

        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .lightGray
        saveButton.layer.cornerRadius = 16

        // 하단 툴바 버튼들 (아이콘은 시스템 아이콘 예시)
        drawModeButton.setImage(UIImage(systemName: "pencil.and.outline"), for: .normal)
        drawModeButton.tintColor = .white

        imageModeButton.setImage(UIImage(systemName: "plus.rectangle.on.rectangle"), for: .normal)
        imageModeButton.tintColor = .white

        undoButton.setImage(UIImage(systemName: "arrow.uturn.backward"), for: .normal)
        undoButton.tintColor = .white

        redoButton.setImage(UIImage(systemName: "arrow.uturn.forward"), for: .normal)
        redoButton.tintColor = .white
        
        // New drawing tool buttons configuration
        penButton.setImage(UIImage(systemName: "applepencil"), for: .normal)
        penButton.tintColor = .white
        penButton.isHidden = true
        
        eraserButton.setImage(UIImage(systemName: "eraser"), for: .normal)
        eraserButton.tintColor = .white
        eraserButton.isHidden = true
        
        shapeButton.setImage(UIImage(systemName: "square.on.circle"), for: .normal)
        shapeButton.tintColor = .white
        shapeButton.isHidden = true
        
        colorButton.setImage(UIImage(systemName: "paintbrush"), for: .normal)
        colorButton.tintColor = .white
        colorButton.isHidden = true
        
        drawingToolButtons = [penButton, eraserButton, shapeButton, colorButton]
        
        setSelectedRatio("9:16")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSelectedRatio(selectedRatio)
    }

    func setSelectedRatio(_ ratio: String) {
        selectedRatio = ratio
        ratioButtons.forEach { button in
            button.isSelected = button.title(for: .normal) == ratio
        }
        
        let width = UIScreen.main.bounds.width - 32
        var newHeight: CGFloat = 500 // Default height
        
        switch ratio {
        case "1:1":
            newHeight = width
        case "3:4":
            newHeight = width * 4 / 3
        case "9:16":
            newHeight = width * 16 / 9
        default:
            break
        }
        
        // Save absolute center position in screen coordinates
        let globalCenter = editableImageView.superview?.convert(editableImageView.center, to: nil)
        let savedTransform = editableImageView.transform

        canvasHeightConstraint?.update(offset: newHeight)
        layoutIfNeeded()

        // Restore center using global to local conversion
        if let global = globalCenter {
            let local = canvasView.convert(global, from: nil)
            editableImageView.center = local
        }
        editableImageView.transform = savedTransform
    }
    
}
