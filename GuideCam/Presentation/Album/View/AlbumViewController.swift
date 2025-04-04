//
//  AlbumViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import UIKit

final class AlbumViewController: BaseViewController<BaseView, AlbumViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print(#function, self)
    }
}
