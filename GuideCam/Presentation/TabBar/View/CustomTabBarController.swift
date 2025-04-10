//
//  CustomTabBarController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

final class CustomTabBarController: UITabBarController, UINavigationControllerDelegate {

    let customTabBar = CustomTabBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.isHidden = true // 시스템이 다시 보여주더라도 계속 숨김 유지
    }

    private func setupCustomTabBar() {
        print(#function, "+++++++++++++++++++")
        
        if customTabBar.superview != nil {
            return // 이미 추가되어 있음
        }
        
        tabBar.isHidden = true
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

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let shouldHideTabBar = viewController.hidesBottomBarWhenPushed
        customTabBar.isHidden = shouldHideTabBar
    }
    
}

extension CustomTabBarController: CustomTabBarDelegate {
    func didSelectTab(index: Int) {
        selectTab(index: index)
    }

}
