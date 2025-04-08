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
    let isInDeleteMode = BehaviorRelay<Bool>(value: false)
    let selectedGuides = BehaviorRelay<[Guide]>(value: [])

    init(repository: GuideRepository = GuideRepositoryImpl()) {
        self.repository = repository
    }

    func loadGuides() {
        let allGuides = repository.fetchAll().map { $0.toModel() }
        guides.accept(allGuides)
    }

    func toggleDeleteMode() {
        isInDeleteMode.accept(!isInDeleteMode.value)
        if isInDeleteMode.value == false {
            selectedGuides.accept([])
        }
    }

    func toggleSelection(at indexPath: IndexPath) {
        var currentSelected = selectedGuides.value
        let guide = guides.value[indexPath.item]
        if let index = currentSelected.firstIndex(where: { $0.thumbnailPath == guide.thumbnailPath }) {
            currentSelected.remove(at: index)
        } else {
            currentSelected.append(guide)
        }
        selectedGuides.accept(currentSelected)
    }

    func isSelected(_ guide: Guide) -> Bool {
        return selectedGuides.value.contains(where: { $0.thumbnailPath == guide.thumbnailPath })
    }

    func deleteSelectedGuides() {
        let guidesToDelete = selectedGuides.value
        for guide in guidesToDelete {
            repository.delete(by: guide.id)
            GuideFileManager.shared.deleteImage(at: guide.thumbnailPath)
        }
        loadGuides()
        selectedGuides.accept([])
        isInDeleteMode.accept(false)
    }
}
