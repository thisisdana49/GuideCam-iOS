//
//  GuideListViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit
import RxSwift
import RxCocoa

final class GuideListViewController: BaseViewController<GuideListView, GuideListViewModel> {
    
    weak var coordinator: GuideListCoordinating?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadGuides()
        mainView.deleteButton.addTarget(self, action: #selector(deleteSelectedGuides), for: .touchUpInside)
        mainView.createGuideButton.addTarget(self, action: #selector(createNewGuide), for: .touchUpInside)
    }

    override func bind() {
        viewModel.guides
            .bind(to: mainView.collectionView.rx.items(
                cellIdentifier: "GuideThumbnailCell",
                cellType: GuideThumbnailCell.self
            )) { index, guide, cell in
                cell.configure(with: guide)
                cell.updateSelectedState(self.viewModel.isSelected(guide))
            }
            .disposed(by: disposeBag)

        mainView.collectionView.rx.modelSelected(Guide.self)
            .subscribe(onNext: { guide in
                print("Selected guide: \(guide.title)")
            })
            .disposed(by: disposeBag)

        viewModel.isInDeleteMode
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isDeleteMode in
                self?.mainView.deleteButton.isHidden = !isDeleteMode
                self?.mainView.createGuideButton.isHidden = isDeleteMode
            })
            .disposed(by: disposeBag)

        mainView.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                guard self.viewModel.isInDeleteMode.value else { return }

                self.viewModel.toggleSelection(at: indexPath)

                if let cell = self.mainView.collectionView.cellForItem(at: indexPath) as? GuideThumbnailCell {
                    let guide = self.viewModel.guides.value[indexPath.item]
                    cell.updateSelectedState(self.viewModel.isSelected(guide))
                }
            })
            .disposed(by: disposeBag)

        viewModel.selectedGuidesCount
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] count in
                self?.mainView.updateDeleteButtonStyle(for: count)
            })
            .disposed(by: disposeBag)
    }
  
    override func configure() {
        let createAction = UIAction(title: "생성", image: UIImage(systemName: "plus")) { [weak self] _ in
            self?.coordinator?.showCreateGuide()
        }

        let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.viewModel.toggleDeleteMode()
        }

        let menu = UIMenu(title: "", options: .displayInline, children: [createAction, deleteAction])
        let menuItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)

        let settingItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingTapped))

        navigationItem.rightBarButtonItems = [menuItem, settingItem]
        
        let homeTitleLabel = UILabel()
        homeTitleLabel.text = "Home"
        homeTitleLabel.textColor = .white
        homeTitleLabel.font = .boldSystemFont(ofSize: 28)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: homeTitleLabel)
    }
    
    @objc private func deleteSelectedGuides() {
        viewModel.deleteSelectedGuides()
    }

    @objc private func createNewGuide() {
        coordinator?.showCreateGuide()
    }

    @objc private func settingTapped() {
        print("⚙️ 설정 버튼이 눌렸습니다 (추후 설정 화면 이동 예정)")
    }
    
    func refreshGuideList() {
        viewModel.loadGuides()
    }
    
}
