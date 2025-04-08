//
//  RealmGuideObject.swift
//  GuideCam
//
//  Created by 조다은 on 4/8/25.
//

import Foundation
import RealmSwift

final class GuideEntity: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var title: String
    @Persisted var thumbnailPath: String
    @Persisted var isFavorite: Bool
    @Persisted var isRecent: Bool
    @Persisted var createdAt: Date = Date()
}


extension GuideEntity {
    func toModel() -> Guide {
        return Guide(
            id: self.id,
            title: self.title,
            thumbnailPath: self.thumbnailPath,
            isFavorite: self.isFavorite,
            isRecent: self.isRecent
        )
    }
}
