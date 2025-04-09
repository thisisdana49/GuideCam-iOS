//
//  GuideSelectionViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/10/25.
//

import UIKit
import SnapKit

final class GuideSelectionViewController: BaseViewController<BaseView, GuideSelectionViewModel> {
    
    var onGuideSelected: ((Guide) -> Void)?

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = false
        setupCollectionView()
        viewModel.loadGuides()
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let itemSize = (UIScreen.main.bounds.width - 12 * 6) / 5
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(GuideSelectionCell.self, forCellWithReuseIdentifier: "GuideSelectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

extension GuideSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.guides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GuideSelectionCell", for: indexPath) as? GuideSelectionCell else {
            return UICollectionViewCell()
        }
        let guide = viewModel.guides[indexPath.item]
        cell.configure(with: guide)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGuide = viewModel.guides[indexPath.item]

        // 선택 시 하이라이트 표시
        if let cell = collectionView.cellForItem(at: indexPath) as? GuideSelectionCell {
            cell.updateSelectedState(true)
        }

        // 콜백 전달 후 모달 닫기
        onGuideSelected?(selectedGuide)
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GuideSelectionCell {
            cell.updateSelectedState(false)
        }
    }
}
