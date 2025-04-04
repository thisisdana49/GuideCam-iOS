//
//  BaseViewController.swift
//  GuideCam
//
//  Created by 조다은 on 4/3/25.
//

import UIKit

class BaseViewController<View: BaseView, ViewModel>: UIViewController {

    let mainView = View()
    let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }

    func configure() { }

    func bind() { }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
