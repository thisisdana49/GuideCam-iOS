import Foundation
import RealmSwift

enum RealmConfiguration {
    static let schemaVersion: UInt64 = 2
    
    static var configuration: Realm.Configuration {
        return Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                print("Migrating from version \(oldSchemaVersion) to \(schemaVersion)")
                if oldSchemaVersion < schemaVersion {
                    print("Adding GuidePhotoEntity to schema")
                }
            },
            shouldCompactOnLaunch: { totalBytes, usedBytes in
                print("Realm file size: \(totalBytes) bytes, used: \(usedBytes) bytes")
                return false
            }
        )
    }
    
    static func configure() {
        Realm.Configuration.defaultConfiguration = configuration
    }
    
    // MARK: - Debug Methods
    
    static func printCurrentSchemaVersion() {
        do {
            let realm = try Realm()
            print("Current Schema Version: \(realm.configuration.schemaVersion)")
        } catch {
            print("Error accessing Realm: \(error)")
        }
    }
    
    static func validateMigration() {
        do {
            let realm = try Realm()
            
            // 기존 Guide 엔티티 확인
            let guides = realm.objects(GuideEntity.self)
            print("Existing guides count: \(guides.count)")
            
            // 새로운 GuidePhoto 엔티티 확인
            let photos = realm.objects(GuidePhotoEntity.self)
            print("New GuidePhoto count: \(photos.count)")
            
            // 스키마 정보 출력
            print("Schema version: \(realm.configuration.schemaVersion)")
            print("Schema types: \(realm.schema.objectSchema.map { $0.className })")
            
        } catch {
            print("Migration validation error: \(error)")
        }
    }
} 
