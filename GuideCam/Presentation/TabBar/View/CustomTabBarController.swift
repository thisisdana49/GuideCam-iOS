//
//  CustomTabBarController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

final class CustomTabBarController: UITabBarController, UINavigationControllerDelegate {

    private let customTabBar = CustomTabBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
    }

    private func setupCustomTabBar() {
//        tabBar.isHidden = true
        view.addSubview(customTabBar)

        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 44)
        ])

        customTabBar.delegate = self
    }

    func selectTab(index: Int) {
        self.selectedIndex = index
    }
    
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        let shouldHideTabBar = viewController.hidesBottomBarWhenPushed
//        customTabBar.isHidden = shouldHideTabBar
//    }
}

extension CustomTabBarController: CustomTabBarDelegate {
    func didSelectTab(index: Int) {
        selectTab(index: index)
    }

}
