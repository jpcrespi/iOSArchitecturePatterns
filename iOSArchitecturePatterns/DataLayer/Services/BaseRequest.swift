//
//  BaseRequest.swift
//  IronRevival
//
//  Created by Juan Pablo on 03/08/2020.
//  Copyright © 2020 Nimble.LA. All rights reserved.
//

import Foundation
import SwiftExtension

//class {Name}Request: BaseRequest<{ModelToSend}, {Name}Request.Data, {RequestResponseType}> {
//
//    class Data: NSObject, Codable {
//        var {key}: {ModelToParse}?
//    }
//
//    override init(data: {ModelToSend}) {
//        super.init(name: {ServiceName},
//                   path: {ServicePath},
//                   method: {ServiceMethod},
//                   data: data)
//    }
//}

class BaseRespose<U: Codable>: NSObject, SEResponseDelegate {
    typealias DataType = U
    
    var statusCode: Int?
    var statusMessage: String?
    var success: Bool?
    var results: U?
    
    required override init() {
        self.success = true
    }
    
    required init(data: U) {
        self.success = true
        self.results = data
    }
    
    required init(error: NSError) {
        self.success = false
        self.statusCode = error.code
        self.statusMessage = error.localizedDescription
    }
}

class BaseRequest<T, U: Codable, V>: SENetwork<T, BaseRespose<U>, V>.Request {
 
    override func baseUrl() -> String {
        return "https://api.themoviedb.org/3"
    }
    
    override func headers() throws -> [String: String] {
        var headers = try super.headers()
        headers["device"] = "ios"
        return headers
    }
    
    override func body() throws -> [String : AnyObject]? {
        var body = try super.body() ?? [:]
        body["api_key"] = "55a70a49d864e9df14557644e47ee12f" as AnyObject?
        return body
    }
}
