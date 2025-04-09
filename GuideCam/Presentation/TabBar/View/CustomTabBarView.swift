//
//  CustomTabBarView.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

protocol CustomTabBarDelegate: AnyObject {
    func didSelectTab(index: Int)
}

final class CustomTabBarView: UIView {

    weak var delegate: CustomTabBarDelegate?

    private let homeButton = UIButton()
    private let cameraButton = UIButton()
    private let indicatorView = UIView()
    private var selectedIndex: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupViews() {
        backgroundColor = .black

        homeButton.setTitle("Home", for: .normal)
        homeButton.setTitleColor(.white, for: .normal)
        homeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        homeButton.tag = 0
        homeButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

        cameraButton.setTitle("Camera", for: .normal)
        cameraButton.setTitleColor(.white, for: .normal)
        cameraButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        cameraButton.tag = 1
        cameraButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

        addSubview(homeButton)
        addSubview(cameraButton)
        indicatorView.backgroundColor = .yellow
        addSubview(indicatorView)
    }

    private func setupLayout() {
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            homeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            homeButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            cameraButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            cameraButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        layoutIfNeeded()
        indicatorView.frame = CGRect(
            x: homeButton.frame.minX,
            y: 0,
            width: homeButton.frame.width,
            height: 4
        )
        
        updateSelectionUI(to: 0)
    }

    private func updateSelectionUI(to index: Int) {
        let selectedButton = index == 0 ? homeButton : cameraButton

        homeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: index == 0 ? .bold : .semibold)
        cameraButton.titleLabel?.font = .systemFont(ofSize: 16, weight: index == 1 ? .bold : .semibold)

        let totalWidth = UIScreen.main.bounds.width
//        let indicatorWidth = (totalWidth - 48) / 2  // 20pt padding on each side
        let indicatorWidth = (totalWidth) / 2

        UIView.animate(withDuration: 0.2) {
            self.indicatorView.frame = CGRect(
//                x: 24 + CGFloat(index) * indicatorWidth,
                x: CGFloat(index) * indicatorWidth,
                y: 0,
                width: indicatorWidth,
                height: 4
            )
        }
    }

    @objc private func tabButtonTapped(_ sender: UIButton) {
        updateSelectionUI(to: sender.tag)
        delegate?.didSelectTab(index: sender.tag)
    }

}
