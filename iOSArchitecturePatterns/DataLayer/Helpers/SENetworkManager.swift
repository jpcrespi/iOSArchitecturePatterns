//
//  SENetworkManager.swift
//  Covid-19
//
//  Created by Juan Pablo on 01/04/2020.
//  Copyright © 2020 Juan Pablo Crespi. All rights reserved.
//

import Foundation

public protocol SENetworkDelegate: class {
    func initService(name: String)
    func finishService(name: String)
}

public protocol SEResponseDelegate: class, Codable {
    associatedtype DataType
    init()
    init(data: DataType)
    init(error: NSError)
}

open class SENetworkManager: NSObject {
    
    open class var instance: SENetworkManager {
        struct Static {
            static let instance = SENetworkManager()
        }
        return Static.instance
    }
    
    internal let requestQueue: DispatchQueue
    internal let responseQueue: DispatchQueue

    override init() {
        requestQueue = DispatchQueue(label: "service.manager.request.queue")
        responseQueue = DispatchQueue(label: "service.manager.response.queue")
    }
}

open class SENetwork<T, U: SEResponseDelegate, V> {

    open class Completion: SEBaseResponse<V> {
        
        open var result: V?
        open var error: NSError?
        open var response: HTTPURLResponse?

        open override func service(result: V, response: HTTPURLResponse? = nil) -> Self {
            self.result = result
            self.response = response
            return self
        }
        
        open override func service(error: NSError, response: HTTPURLResponse? = nil) -> Self {
            self.error = error
            self.response = response
            return self
        }
    }

    open class Request: NSObject {

        private var data: T?
        private var path: String
        private var method: SEMethod
        private var completion: Completion
        private var name: String
    
        public init(data: T) {
            fatalError("This function should be overrided")
        }
    
        public init(name: String,
                    path: String,
                    method: SEMethod,
                    data: T? = nil) {
            self.name = name
            self.path = path
            self.method = method
            self.data = data
            self.completion = Completion()
        }
        
        open func body() throws -> [String: AnyObject]? {
            if let data = data {
                if let codable = data as? Codable {
                    return try codable.dictionary()
                } else {
                    throw NSError()
                }
            } else {
                return nil
            }
        }
        
        open func headers() throws -> [String: String] {
            var headers = [String: String]()
            
            headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
            headers["Pragma"] = "no-cache"
            headers["Expires"] = "0"

            return headers
        }
        
        open func baseUrl() -> String {
            fatalError()
        }

        open func url() throws -> String {
            return "\(baseUrl())\(path)"
        }
        
        open func responseType() -> SEResponseType {
            return .JSON
        }
        
        open func parameterEncoding() -> SEParameterEncoding {
            switch method {
            case .get:
                return .URL
            default:
                return .JSON
            }
        }
        
        open func performRequest(delegate: SENetworkDelegate? = nil,
                                 completion: @escaping (() -> Void)) {
            SENetworkManager.instance.requestQueue.async {
                do {
                    let service = try SEBaseRequest(method: self.method,
                                                    encoding: self.parameterEncoding(),
                                                    path: try self.url(),
                                                    response: self.completion,
                                                    responseType: self.responseType(),
                                                    headers: try self.headers(),
                                                    body: try self.body())
                    delegate?.initService(name: self.name)
                    _ = service.perform { _ in
                        delegate?.finishService(name: self.name)
                        DispatchQueue.main.async(execute: completion)
                    }
                } catch {
                    self.completion.error = error as NSError
                    DispatchQueue.main.async(execute: completion)
                }
            }
        }
        
        open func performResponse(completion: @escaping ((U) -> Void)) {
            SENetworkManager.instance.responseQueue.async {
                do {
                    if let error = self.completion.error {
                        throw error
                    }
                    guard let result = self.completion.result else {
                        DispatchQueue.main.async { completion(U()) }
                        return
                    }
                    var response: U
                    switch self.responseType() {
                    case .JSON:
                        guard let json = result as? [String: Any] else { throw NSError() }
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        response = try JSONDecoder().decode(U.self, from: data)
                    case .string, .data:
                        guard let data = result as? U.DataType else { throw NSError() }
                        response = U(data: data)
                    }
                    DispatchQueue.main.async { completion(response) }
                } catch {
                    DispatchQueue.main.async { completion(U(error: error as NSError)) }
                }
            }
        }
    }
}
