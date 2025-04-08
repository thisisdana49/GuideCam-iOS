//
//  GuideRepository.swift
//  GuideCam
//
//  Created by 조다은 on 4/8/25.
//

import Foundation
import RealmSwift

protocol GuideRepository {
    func save(_ guide: GuideEntity)
    func fetchAll() -> [GuideEntity]
    func delete(_ guide: GuideEntity)
    func update(_ guide: GuideEntity)
}

final class GuideRepositoryImpl: GuideRepository {

    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }

    func save(_ guide: GuideEntity) {
        do {
            try realm.write {
                realm.add(guide)
            }
        } catch {
            print("❌ Save Guide Failed: \(error)")
        }
    }

    func fetchAll() -> [GuideEntity] {
        return Array(realm.objects(GuideEntity.self).sorted(byKeyPath: "createdAt", ascending: false))
    }

    func delete(_ guide: GuideEntity) {
        do {
            try realm.write {
                realm.delete(guide)
            }
        } catch {
            print("❌ Delete Guide Failed: \(error)")
        }
    }

    func update(_ guide: GuideEntity) {
        do {
            try realm.write {
                realm.add(guide, update: .modified)
            }
        } catch {
            print("❌ Update Guide Failed: \(error)")
        }
    }
}
