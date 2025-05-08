import XCTest
import RealmSwift
@testable import GuideCam

class RealmMigrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // 테스트용 Realm 설정
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            inMemoryIdentifier: "test-realm",
            schemaVersion: 1
        )
    }
    
    override func tearDown() {
        super.tearDown()
        // 테스트 후 Realm 정리
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func testMigrationPreservesExistingData() {
        // 기존 데이터 생성 (v1)
        let realm = try! Realm()
        try! realm.write {
            let guide = GuideEntity()
            guide.title = "Test Guide"
            guide.thumbnailPath = "test/path"
            guide.isFavorite = true
            guide.isRecent = true
            realm.add(guide)
        }
        
        // 마이그레이션 실행 (v2)
        RealmConfiguration.configure()
        
        // 데이터 검증
        let migratedRealm = try! Realm()
        let guides = migratedRealm.objects(GuideEntity.self)
        
        // 기존 데이터가 보존되었는지 확인
        XCTAssertEqual(guides.count, 1)
        XCTAssertEqual(guides.first?.title, "Test Guide")
        XCTAssertEqual(guides.first?.thumbnailPath, "test/path")
        XCTAssertEqual(guides.first?.isFavorite, true)
        XCTAssertEqual(guides.first?.isRecent, true)
        
        // 새로운 스키마가 추가되었는지 확인
        XCTAssertTrue(migratedRealm.schema.objectSchema.contains { $0.className == "GuidePhotoEntity" })
    }
    
    func testGuidePhotoEntityCreation() {
        // 마이그레이션 실행
        RealmConfiguration.configure()
        
        let realm = try! Realm()
        
        // GuidePhotoEntity 생성 테스트
        try! realm.write {
            let photo = GuidePhotoEntity(guideId: "test-guide-id", assetLocalIdentifier: "test-asset-id")
            realm.add(photo)
        }
        
        // 데이터 검증
        let photos = realm.objects(GuidePhotoEntity.self)
        XCTAssertEqual(photos.count, 1)
        XCTAssertEqual(photos.first?.guideId, "test-guide-id")
        XCTAssertEqual(photos.first?.assetLocalIdentifier, "test-asset-id")
    }
} 
