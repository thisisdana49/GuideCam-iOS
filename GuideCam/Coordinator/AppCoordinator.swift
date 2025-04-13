//
//  AppCoordinator.swift
//  GuideCam
//
//  Created by 조다은 on 4/3/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        print(#function)
        let tabBarCoordinator = TabBarCoordinator()
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
        window.rootViewController = tabBarCoordinator.tabBarController
        window.makeKeyAndVisible()
    }
}
