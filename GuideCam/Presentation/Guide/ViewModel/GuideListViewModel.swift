//
//  GuideListViewModel.swift
//  GuideCam
//
//  Created by 조다은 on 4/4/25.
//

import Foundation
import RxSwift
import RxCocoa

final class GuideListViewModel: BaseViewModel {
    let guides = BehaviorRelay<[Guide]>(value: [])

    func loadDummyData() {
        let dummy = [
            Guide(title: "Pose A", thumbnailPath: "", isFavorite: true, isRecent: true),
            Guide(title: "Pose B", thumbnailPath: "", isFavorite: false, isRecent: false),
            Guide(title: "Pose C", thumbnailPath: "", isFavorite: true, isRecent: false)
        ]
        guides.accept(dummy)
    }
}
