//
//  CreateGuideViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

final class CreateGuideViewController: BaseViewController<CreateGuideView, CreateGuideViewModel> {

    weak var coordinator: GuideListCoordinating?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function, self)
        navigationController?.setNavigationBarHidden(true, animated: false)
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func configure() {
        
    }
    
    override func bind() {
        super.bind()
        
        for button in mainView.ratioButtons {
            button.addTarget(self, action: #selector(ratioButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func ratioButtonTapped(_ sender: UIButton) {
        guard let ratio = sender.titleLabel?.text else { return }
        mainView.setSelectedRatio(ratio)
    }
    
    @objc private func backButtonTapped() {
        coordinator?.didFinishCreateGuide()
    }
}
