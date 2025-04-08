//
//  GuideListCoordinator.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

protocol GuideListCoordinating: AnyObject {
    func showCreateGuide()
    func showSaveConfirm(thumbnailPath: String, title: String)
    func didFinishCreateGuide()
}

final class GuideListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = GuideListViewModel()
        let viewController = GuideListViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
}

extension GuideListCoordinator: GuideListCoordinating {
    func showCreateGuide() {
        let createViewModel = CreateGuideViewModel()
        let createVC = CreateGuideViewController(viewModel: createViewModel)
        createVC.coordinator = self
        createVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(createVC, animated: true)
    }
    
    func showSaveConfirm(thumbnailPath: String, title: String) {
        let confirmViewModel = ConfirmSaveGuideViewModel()
        let confirmVC = ConfirmSaveGuideViewController(thumbnailPath: thumbnailPath, title: title, viewModel: confirmViewModel)
        confirmVC.hidesBottomBarWhenPushed = true
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(confirmVC, animated: true)
    }
    
    func didFinishCreateGuide() {
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.popViewController(animated: true)
    }
}
