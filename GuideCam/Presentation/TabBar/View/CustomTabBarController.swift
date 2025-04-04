//
//  CustomTabBarController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

final class CustomTabBarController: UITabBarController {

    private let customTabBar = CustomTabBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
    }

    private func setupCustomTabBar() {
        tabBar.isHidden = true  // 기본 탭바 숨김
        view.addSubview(customTabBar)

        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 80)
        ])

        customTabBar.delegate = self
    }

    func selectTab(index: Int) {
        self.selectedIndex = index
    }
}

extension CustomTabBarController: CustomTabBarDelegate {
    func didSelectTab(index: Int) {
        selectTab(index: index)
    }

}
