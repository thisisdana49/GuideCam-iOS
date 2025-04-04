//
//  CameraViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

final class CameraViewController: BaseViewController<BaseView, CameraViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print(#function, self)
    }
}
