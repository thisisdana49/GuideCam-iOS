//
//  AlbumCoordinator.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

final class AlbumCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = AlbumViewModel()
        let viewController = AlbumViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]
    }
}
