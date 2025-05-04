import Foundation
import RealmSwift

enum RealmConfiguration {
    static let schemaVersion: UInt64 = 2
    
    static var configuration: Realm.Configuration {
        return Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < schemaVersion {
                    // GuidePhotoEntity가 자동으로 추가됨
                }
            }
        )
    }
    
    static func configure() {
        Realm.Configuration.defaultConfiguration = configuration
    }
} 