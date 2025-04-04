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
        view.backgroundColor = .systemBackground
    }
}
