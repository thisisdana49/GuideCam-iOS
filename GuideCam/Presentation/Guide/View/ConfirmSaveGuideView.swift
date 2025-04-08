//  ConfirmSaveGuideView.swift
//  GuideCam
//
//  Created by 조다은 on 4/8/25.
//

import UIKit
import SnapKit

final class ConfirmSaveGuideView: BaseView {
    
    let homeButton = UIButton()
    let savedImageView = UIImageView()
    let statusLabel = UILabel()
    let titleField = UITextField()
    let renameButton = UIButton()
    let shootButton = UIButton()
    let viewGuideListButton = UIButton()

    override func configureHierarchy() {
        addSubview(homeButton)
        addSubview(savedImageView)
        addSubview(statusLabel)
        addSubview(titleField)
        addSubview(renameButton)
        addSubview(shootButton)
        addSubview(viewGuideListButton)
    }

    override func configureLayout() {
        homeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }

        savedImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(homeButton.snp.bottom).offset(24)
            $0.width.height.equalTo(280)
        }

        statusLabel.snp.makeConstraints {
            $0.top.equalTo(savedImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        titleField.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        renameButton.snp.makeConstraints {
            $0.leading.equalTo(titleField.snp.trailing).offset(8)
            $0.centerY.equalTo(titleField)
            $0.width.height.equalTo(20)
        }

        shootButton.snp.makeConstraints {
            $0.top.equalTo(titleField.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
            $0.width.equalTo(260)
        }

        viewGuideListButton.snp.makeConstraints {
            $0.top.equalTo(shootButton.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = .black

        homeButton.setImage(UIImage(systemName: "house"), for: .normal)
        homeButton.tintColor = .white

        savedImageView.contentMode = .scaleAspectFit
        savedImageView.clipsToBounds = true

        statusLabel.text = "✅ Save Completed"
        statusLabel.textColor = .yellow
        statusLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        titleField.text = "Heart_1"
        titleField.textColor = .white
        titleField.font = .boldSystemFont(ofSize: 20)
        titleField.borderStyle = .none
        titleField.textAlignment = .center
        titleField.isUserInteractionEnabled = true
        titleField.returnKeyType = .done

        renameButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        renameButton.tintColor = .white

        shootButton.setTitle("Take shot with this guide", for: .normal)
        shootButton.backgroundColor = .white
        shootButton.setTitleColor(.black, for: .normal)
        shootButton.layer.cornerRadius = 12
        shootButton.titleLabel?.font = .boldSystemFont(ofSize: 16)

        viewGuideListButton.setTitle("View Guide List", for: .normal)
        viewGuideListButton.setTitleColor(.white, for: .normal)
        viewGuideListButton.titleLabel?.font = .systemFont(ofSize: 14)
//        viewGuideListButton.titleLabel?.underlineStyle = .single
    }
}
