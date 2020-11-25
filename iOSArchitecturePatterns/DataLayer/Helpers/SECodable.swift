//
//  SECodable.swift
//
//  Created by Juan Pablo on 29/03/2020.
//  Copyright © 2020 Juan Pablo Crespi.. All rights reserved.
//

import Foundation

class CodableData<T: Codable>: NSObject, Codable {
    
    var data: T
    
    init(data: T) {
        self.data = data
    }
}

extension Encodable {
    
    func dictionary() throws -> [String: AnyObject] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let dict = json as? [String: AnyObject] else { throw NSError() }
        return dict
    }
}

extension Decodable {
    
    init(dictionary: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

public let SECodableErrorDomain: String = "SECodableErrorDomain"

open class SECodable: NSObject {
    
    public enum Directory {
        case resource
        case document
    }
    
    open class var instance: SECodable {
        struct Static {
            static let instance = SECodable()
        }
        return Static.instance
    }
    
    private let queue: DispatchQueue
    private var documentsDirectory: URL?
    private var resourcesDirectory: URL?
    
    override init() {
        resourcesDirectory = Bundle.main.resourceURL
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        queue = DispatchQueue(label: "data.manager.queue")
    }
    
    private func filePath(withFilename filename: String, directory: Directory) throws -> URL {
        switch directory {
        case .resource:
            if let path = resourcesDirectory {
                return path.appendingPathComponent(filename)
            } else {
                throw error(code: 101, message: "Nil Path")
            }
        case .document:
            if let path = documentsDirectory {
                return path.appendingPathComponent(filename)
            } else {
                throw error(code: 101, message: "Nil Path")
            }
        }
    }

    private func fileExists(at url: URL) throws {
        if FileManager.default.fileExists(atPath: url.path) == false {
            throw error(code: 102, message: "File Does Not Exist")
        }
    }
    
    private func error(code: Int, message: String) -> NSError {
        return NSError(domain: SECodableErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }

    private func write<T: Codable>(filename: String, object: T) throws {
        let path = try self.filePath(withFilename: filename, directory: .document)
        let data = try JSONEncoder().encode(object)
        try data.write(to: path)
    }
    
    private func read<T: Codable>(filename: String, directory: Directory) throws -> T {
        let path = try self.filePath(withFilename: filename, directory: directory)
        try self.fileExists(at: path)
        let data = try Data(contentsOf: path)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func remove(filename: String) throws {
        let path = try self.filePath(withFilename: filename, directory: .document)
        try self.fileExists(at: path)
        try FileManager.default.removeItem(at: path)
    }
    
    open func write<T: Codable>(filename: String, object: T, completion: @escaping ((NSError?) -> Void)) {
        queue.async {
            do {
                try self.write(filename: filename, object: object)
                DispatchQueue.main.async { completion(nil) }
            } catch {
                DispatchQueue.main.async { completion(error as NSError) }
            }
        }
    }
    
    open func read<T: Codable>(filename: String, directory: Directory, completion: @escaping ((T?, NSError?) -> Void)) {
        queue.async {
            do {
                let object: T = try self.read(filename: filename, directory: directory)
                DispatchQueue.main.async { completion(object, nil) }
            } catch {
                DispatchQueue.main.async { completion(nil, error as NSError) }
            }
        }
    }
    
    open func remove(filename: String, completion: @escaping ((NSError?) -> Void)) {
        queue.async {
            do {
                try self.remove(filename: filename)
                DispatchQueue.main.async { completion(nil) }
            } catch {
                DispatchQueue.main.async { completion(error as NSError) }
            }
        }
    }
    
    open func exists(filename: String, directory: Directory, completion: @escaping ((Bool) -> Void)) {
        queue.async {
            do {
                let path = try self.filePath(withFilename: filename, directory: directory)
                try self.fileExists(at: path)
                DispatchQueue.main.async { completion(true) }
            } catch {
                DispatchQueue.main.async { completion(false) }
            }
        }
    }
}
