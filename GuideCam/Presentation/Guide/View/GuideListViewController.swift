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
    }

    override func bind() {
        viewModel.guides
            .bind(to: mainView.collectionView.rx.items(
                cellIdentifier: "GuideThumbnailCell",
                cellType: GuideThumbnailCell.self
            )) { index, guide, cell in
                cell.configure(with: guide)
            }
            .disposed(by: disposeBag)

        mainView.collectionView.rx.modelSelected(Guide.self)
            .subscribe(onNext: { guide in
                print("Selected guide: \(guide.title)")
            })
            .disposed(by: disposeBag)
    }

    override func configure() {
        let createAction = UIAction(title: "생성", image: UIImage(systemName: "plus")) { [weak self] _ in
            print("가이드 생성 버튼 클릭됨")
            print(self?.coordinator)
            self?.coordinator?.showCreateGuide()
        }

        let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            print("가이드 삭제 버튼 클릭됨")
            // self?.viewModel.handleDeleteMode()
        }

        let menu = UIMenu(title: "", options: .displayInline, children: [createAction, deleteAction])
        let menuItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)

        navigationItem.rightBarButtonItem = menuItem
    }
    
    func refreshGuideList() {
        viewModel.loadGuides()
    }
    
}
