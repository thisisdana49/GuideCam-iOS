//
//  ConfirmSaveGuideViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/5/25.
//

import Foundation

final class ConfirmSaveGuideViewController: BaseViewController<ConfirmSaveGuideView, ConfirmSaveGuideViewModel> {
    private let thumbnailPath: String
    private let titleText: String

    init(thumbnailPath: String, title: String, viewModel: ConfirmSaveGuideViewModel) {
        self.thumbnailPath = thumbnailPath
        self.titleText = title
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.savedImageView.image = GuideFileManager.shared.loadImage(from: thumbnailPath)
        mainView.titleField.text = titleText
    }
}
