//
//  CreateGuideViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

final class CreateGuideViewController: BaseViewController<CreateGuideView, CreateGuideViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function, self)
        title = "가이드 생성"
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
}
