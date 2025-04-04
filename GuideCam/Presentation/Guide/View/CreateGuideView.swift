//
//  CreateGuideView.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit
import SnapKit

final class CreateGuideView: BaseView {

    let ratioStackView = UIStackView()
    let saveButton = UIButton()
    let canvasView = UIView()

    let drawModeButton = UIButton()
    let imageModeButton = UIButton()
    let undoButton = UIButton()
    let redoButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        addSubview(ratioStackView)
        addSubview(saveButton)
        addSubview(canvasView)

        addSubview(drawModeButton)
        addSubview(imageModeButton)
        addSubview(undoButton)
        addSubview(redoButton)
    }

    override func configureLayout() {
        ratioStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(32)
        }

        saveButton.snp.makeConstraints {
            $0.centerY.equalTo(ratioStackView)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(32)
            $0.width.equalTo(64)
        }

        canvasView.snp.makeConstraints {
            $0.top.equalTo(ratioStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(80)
        }

        drawModeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.width.height.equalTo(40)
        }

        imageModeButton.snp.makeConstraints {
            $0.leading.equalTo(drawModeButton.snp.trailing).offset(16)
            $0.centerY.equalTo(drawModeButton)
            $0.width.height.equalTo(40)
        }

        redoButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(drawModeButton)
            $0.width.height.equalTo(40)
        }

        undoButton.snp.makeConstraints {
            $0.trailing.equalTo(redoButton.snp.leading).offset(-16)
            $0.centerY.equalTo(redoButton)
            $0.width.height.equalTo(40)
        }
    }

    override func configureView() {
        backgroundColor = .black

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
        }

        // 상단 저장 버튼
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.backgroundColor = .lightGray
        saveButton.layer.cornerRadius = 16
        saveButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)

        // 하단 툴바 버튼들 (아이콘은 시스템 아이콘 예시)
        drawModeButton.setImage(UIImage(systemName: "pencil.and.outline"), for: .normal)
        drawModeButton.tintColor = .white

        imageModeButton.setImage(UIImage(systemName: "plus.rectangle.on.rectangle"), for: .normal)
        imageModeButton.tintColor = .white

        undoButton.setImage(UIImage(systemName: "arrow.uturn.backward"), for: .normal)
        undoButton.tintColor = .white

        redoButton.setImage(UIImage(systemName: "arrow.uturn.forward"), for: .normal)
        redoButton.tintColor = .white
    }
    
}
