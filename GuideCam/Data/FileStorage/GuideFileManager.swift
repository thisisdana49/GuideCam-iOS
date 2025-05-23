//
//  GuideFileManager.swift
//  GuideCam
//
//  Created by 조다은 on 4/8/25.
//

import UIKit

final class GuideFileManager {

    static let shared = GuideFileManager()
    private init() {}

    private let fileManager = FileManager.default

    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func printDocumentsDirectoryPath() {
        let path = documentsDirectory.path
        print("📂 Documents Directory 경로:\n\(path)")
    }
    
    // MARK: - Save

    func saveImage(_ image: UIImage, withName name: String) -> String? {
        printDocumentsDirectoryPath()
        let url = documentsDirectory.appendingPathComponent(name)
        guard let data = image.pngData() else { return nil }

        do {
            try data.write(to: url)
            return name  // Only return file name
        } catch {
            print("❌ 이미지 저장 실패: \(error)")
            return nil
        }
    }

    // MARK: - Load

    func loadImage(from filename: String) -> UIImage? {
        let url = documentsDirectory.appendingPathComponent(filename)
        print(url)
        return UIImage(contentsOfFile: url.path)
    }

    // MARK: - Delete

    func deleteImage(at filename: String) {
        let url = documentsDirectory.appendingPathComponent(filename)
        if fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.removeItem(at: url)
            } catch {
                print("❌ 이미지 삭제 실패: \(error)")
            }
        }
    }

    // MARK: - Unique Filename

    func makeImageFilename() -> String {
        return UUID().uuidString + ".png"
    }
}
