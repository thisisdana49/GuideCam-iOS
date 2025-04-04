//
//  GuideListCoordinator.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

protocol GuideListCoordinating: AnyObject {
    func showCreateGuide()
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
        print(#function)
        let createViewModel = CreateGuideViewModel()
        let createVC = CreateGuideViewController(viewModel: createViewModel)
        createVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(createVC, animated: true)
    }
}
