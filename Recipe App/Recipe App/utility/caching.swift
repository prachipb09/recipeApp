//
//  DirectoryName.swift
//  Recipe App
//
//  Created by Prachi Bharadwaj on 15/10/24.
//


import Foundation
import UIKit

enum DirectoryName: String {
    case images
}

class CacheUtility {
    static let shared: CacheUtility = CacheUtility()

    private let fileManager: FileManager = FileManager.default

    private let inMemCache = NSCache<NSString, UIImage>()

    private init() { }

    private var cacheDirectoryURL: URL {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    private func createDirectory(name: DirectoryName) {
        let directoryURL = cacheDirectoryURL.appendingPathComponent(name.rawValue, isDirectory: true)
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Can't create directory - \(name) due to error - \(error.localizedDescription)")
        }
    }

    func saveImage(_ image: UIImage, forKey key: String, in directory: DirectoryName = .images) {
        let directoryURL = cacheDirectoryURL.appendingPathComponent(directory.rawValue, isDirectory: true)
        if fileManager.fileExists(atPath: directoryURL.path) {
            let fileURL = directoryURL.appendingPathComponent(key)
            guard let data = image.pngData() else { return }
            try? data.write(to: fileURL)
            inMemCache.setObject(image, forKey: key as NSString)
        } else {
            createDirectory(name: directory)
            saveImage(image, forKey: key, in: directory)
        }
    }

    func getImage(forKey key: String, in directory: DirectoryName = .images) -> UIImage? {
        if let cachedImage = inMemCache.object(forKey: key as NSString) {
            return cachedImage
        } else {
            let directoryURL = cacheDirectoryURL.appendingPathComponent(directory.rawValue, isDirectory: true)
            let fileURL = directoryURL.appendingPathComponent(key)
            if fileManager.fileExists(atPath: directoryURL.path) &&
                fileManager.fileExists(atPath: fileURL.path) {
                return UIImage(contentsOfFile: fileURL.path)
            }
            return nil
        }
    }

    func clearImage(in directory: DirectoryName = .images) {
        inMemCache.removeAllObjects()
        let directoryURL = cacheDirectoryURL.appendingPathComponent(directory.rawValue, isDirectory: true)
        try? FileManager.default.removeItem(atPath: directoryURL.path)
    }
}
