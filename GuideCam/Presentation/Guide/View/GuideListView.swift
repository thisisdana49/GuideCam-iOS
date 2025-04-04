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
        collectionView.register(GuideCell.self, forCellWithReuseIdentifier: "GuideCell")
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

    override func configureHierarchy() {
        addSubview(collectionView)
        addSubview(emptyStateLabel)
    }

    override func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }

        emptyStateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = .black
    }
    
}
