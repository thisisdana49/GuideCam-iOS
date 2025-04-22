//
//  TabBarCoordinator.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let tabBarController = CustomTabBarController()

    func start() {
        let guideNav = UINavigationController()
        let cameraNav = UINavigationController()
        // let albumNav = UINavigationController()

        guideNav.delegate = tabBarController
        cameraNav.delegate = tabBarController
        // albumNav.delegate = tabBarController

        let guideCoordinator = GuideListCoordinator(navigationController: guideNav)
        let cameraCoordinator = CameraCoordinator(navigationController: cameraNav)
        // let albumCoordinator = AlbumCoordinator(navigationController: albumNav)

        childCoordinators = [guideCoordinator, cameraCoordinator /*, albumCoordinator */]

        guideCoordinator.start()
        cameraCoordinator.start()
        // albumCoordinator.start()

        tabBarController.viewControllers = [guideNav, cameraNav /*, albumNav */]
    }
}
