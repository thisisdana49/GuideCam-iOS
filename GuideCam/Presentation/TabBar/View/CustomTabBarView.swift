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
    private let albumButton = UIButton()

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

        homeButton.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        homeButton.tag = 0
        homeButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

        cameraButton.setImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        cameraButton.tag = 1
        cameraButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

        albumButton.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        albumButton.tag = 2
        albumButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)

        [homeButton, cameraButton, albumButton].forEach {
            addSubview($0)
            $0.tintColor = .white
        }
    }

    private func setupLayout() {
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        albumButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            homeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            homeButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            albumButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            albumButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            cameraButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 44),
            cameraButton.widthAnchor.constraint(equalToConstant: 44),
        ])
    }

    @objc private func tabButtonTapped(_ sender: UIButton) {
        delegate?.didSelectTab(index: sender.tag)
    }

}
