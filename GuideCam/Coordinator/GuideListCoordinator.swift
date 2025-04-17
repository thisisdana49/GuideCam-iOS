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
    func returnToGuideListRoot()
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
        print(#function, navigationController.viewControllers)
    }
    
    func showSaveConfirm(thumbnailPath: String, title: String) {
        let confirmViewModel = ConfirmSaveGuideViewModel()
        let confirmVC = ConfirmSaveGuideViewController(thumbnailPath: thumbnailPath, title: title, viewModel: confirmViewModel)
        confirmVC.coordinator = self
        confirmVC.hidesBottomBarWhenPushed = true
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(confirmVC, animated: true)
        print(#function, navigationController.viewControllers)
    }
    
    func didFinishCreateGuide() {
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.popViewController(animated: true)
    }
    
    func returnToGuideListRoot() {
        if let guideListVC = navigationController.viewControllers.first(where: { $0 is GuideListViewController }) {
            navigationController.popToViewController(guideListVC, animated: true)
            DispatchQueue.main.async {
                (guideListVC as? GuideListViewController)?.refreshGuideList()
            }
        } else {
            print("GuideListViewController not found in stack")
        }
    }
}
