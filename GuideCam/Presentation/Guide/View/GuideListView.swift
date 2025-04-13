//
//  GuideListView.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit
import SnapKit

final class GuideListView: BaseView {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let itemWidth = (UIScreen.main.bounds.width - 3 * 16) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 30)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(GuideThumbnailCell.self, forCellWithReuseIdentifier: "GuideThumbnailCell")
        return collectionView
    }()

    let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 가이드가 없어요.\n 나만의 가이드를 만들어볼까요? 😎"
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Guide", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 12
        button.isHidden = true
        return button
    }()

    let createGuideButton: UIButton = {
        let button = UIButton()
//        button.setTitle("＋ Create New Guide", for: .normal)
        button.setTitle("＋ 새로운 가이드 만들기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 12
        button.isHidden = false
        return button
    }()

    let sectionHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Guides"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let toggleDeleteModeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .white
        return button
    }()

    override func configureHierarchy() {
        addSubview(collectionView)
        addSubview(emptyStateLabel)
        addSubview(deleteButton)
        addSubview(createGuideButton)
        addSubview(sectionHeaderLabel)
        addSubview(toggleDeleteModeButton)
    }

    override func configureLayout() {
        createGuideButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
            $0.width.equalTo(safeAreaLayoutGuide).inset(20)
        }

        deleteButton.snp.makeConstraints {
            $0.edges.equalTo(createGuideButton)
        }

        sectionHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(createGuideButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        toggleDeleteModeButton.snp.makeConstraints {
            $0.centerY.equalTo(sectionHeaderLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }

        collectionView.snp.remakeConstraints {
            $0.top.equalTo(sectionHeaderLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }

        emptyStateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = .black
    }
    
    // TODO: Button Config로 리팩토링
    func updateDeleteButtonStyle(for count: Int) {
        if count == 0 {
            deleteButton.setTitle("삭제할 가이드 선택하기", for: .normal)
            deleteButton.isEnabled = false
            deleteButton.backgroundColor = .black
            deleteButton.setTitleColor(.gray, for: .normal)
            deleteButton.layer.borderWidth = 1
            deleteButton.layer.borderColor = UIColor.gray.cgColor
        } else {
            deleteButton.setTitle("가이드 \(count)개 삭제하기", for: .normal)
            deleteButton.isEnabled = true
            deleteButton.backgroundColor = .yellow
            deleteButton.setTitleColor(.black, for: .normal)
            deleteButton.layer.borderWidth = 0
        }
    }
}
