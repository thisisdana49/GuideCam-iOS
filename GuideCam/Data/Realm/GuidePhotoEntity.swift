import Foundation
import RealmSwift

final class GuidePhotoEntity: Object {
    @Persisted(primaryKey: true) var id: ObjectId = ObjectId.generate()
    @Persisted var guideId: String
    @Persisted var assetLocalIdentifier: String
    @Persisted var createdAt: Date = Date()
    
    convenience init(guideId: String, assetLocalIdentifier: String) {
        self.init()
        self.guideId = guideId
        self.assetLocalIdentifier = assetLocalIdentifier
    }
}

extension GuidePhotoEntity {
    func toModel() -> GuidePhoto {
        return GuidePhoto(
            id: self.id.stringValue,
            guideId: self.guideId,
            assetLocalIdentifier: self.assetLocalIdentifier,
            createdAt: self.createdAt
        )
    }
} 