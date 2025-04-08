//  GuideListViewModel.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import Foundation
import RxSwift
import RxCocoa

final class GuideListViewModel: BaseViewModel {
    private let repository: GuideRepository
    let guides = BehaviorRelay<[Guide]>(value: [])

    init(repository: GuideRepository = GuideRepositoryImpl()) {
        self.repository = repository
    }

    func loadGuides() {
        let allGuides = repository.fetchAll().map { $0.toModel() }
        guides.accept(allGuides)
    }

}
