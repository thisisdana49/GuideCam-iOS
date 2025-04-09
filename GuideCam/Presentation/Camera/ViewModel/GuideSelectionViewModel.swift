//  GuideSelectionViewModel.swift
//  GuideCam
//
//  Created by 조다은 on 4/10/25.
//

import Foundation

final class GuideSelectionViewModel: BaseViewModel {

    private let repository: GuideRepository
    private(set) var guides: [Guide] = []

    init(repository: GuideRepository = GuideRepositoryImpl()) {
        self.repository = repository
    }

    func loadGuides() {
        let entities = repository.fetchAll()
        self.guides = entities.map { $0.toModel() }
    }
}
