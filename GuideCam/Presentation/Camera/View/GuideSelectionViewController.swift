//
//  GuideSelectionViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/10/25.
//

import UIKit
import SnapKit

final class GuideSelectionViewController: BaseViewController<BaseView, GuideSelectionViewModel> {
    
    var onDismiss: (() -> Void)?
    var onGuideSelected: ((Guide) -> Void)?
    
    private let dimmingView = UIView()
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "저장된 가이드가 없어요.\n먼저 가이드를 만들어볼까요? 😊"
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = false
        setupDimmingView()
        setupModalContainer()
        viewModel.loadGuides()
        collectionView.reloadData()
        updateEmptyState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        
        if let cell = collectionView.cellForItem(at: indexPath) as? GuideSelectionCell {
            cell.updateSelectedState(true)
        }

        onGuideSelected?(selectedGuide)
        onDismiss?()
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GuideSelectionCell {
            cell.updateSelectedState(false)
        }
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.guides.isEmpty
        emptyStateLabel.isHidden = !isEmpty
    }
    
    private func setupDimmingView() {
        dimmingView.backgroundColor = .clear
        view.addSubview(dimmingView)
        dimmingView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissSelf() {
        print(#function)
        onDismiss?()
        dismiss(animated: true)
    }
    
    private func setupModalContainer() {
        let container = UIView()
        container.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        container.layer.cornerRadius = 20
        container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        container.clipsToBounds = true
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
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
        
        container.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        container.addSubview(emptyStateLabel)
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
