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
        label.text = "No guides yet"
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

    override func configureHierarchy() {
        addSubview(collectionView)
        addSubview(emptyStateLabel)
        addSubview(deleteButton)
    }

    override func configureLayout() {
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
            $0.width.equalTo(200)
        }

        collectionView.snp.remakeConstraints {
            $0.top.equalTo(deleteButton.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }

        emptyStateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = .black
    }
    
}
