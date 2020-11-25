//
//  SEBaseRequest.swift
//
//  Created by Juan Pablo Crespi on 21/12/15.
//  Copyright © 2015 Juan Pablo Crespi. All rights reserved.
//

import Foundation
import Alamofire

public enum SEMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public enum SEResponseType {
    case JSON
    case string
    case data
}

public enum SEParameterEncoding {
    case URL
    case JSON
}

open class SEBaseRequest<T: SEBaseResponse<U>, U>: NSObject {
    
    private var method: HTTPMethod
    private var path: URLConvertible
    private var headers: HTTPHeaders = HTTPHeaders.default
    private var encoding: ParameterEncoding
    private var response: T
    private var responseType: SEResponseType
    private var body: [String: AnyObject]?
    private var images: [String: UIImage]?
    private var timeout: TimeInterval
    private var retry: Int
    private var username: String?
    private var password: String?
    
    private var retryCount: Int = 0

    public init(method: SEMethod,
                encoding: SEParameterEncoding,
                path: String,
                response: T,
                responseType: SEResponseType = .JSON,
                headers: [String: String] = [:],
                body: [String: AnyObject]? = nil,
                images: [String: UIImage]? = nil,
                timeout: TimeInterval = 60,
                retry: Int = 0,
                username: String? = nil,
                password: String? = nil) throws {
                        
        switch encoding {
        case .URL:
            self.encoding = URLEncoding.default
        case .JSON:
            self.encoding = JSONEncoding.default
        }
        
        self.method = HTTPMethod(rawValue: method.rawValue)
        self.path = path
        self.response = response
        self.body = body
        self.images = images
        self.responseType = responseType
        self.timeout = timeout
        self.retry = retry
        self.username = username
        self.password = password
        
        super.init()
        
        headers.forEach {
            self.headers.add(HTTPHeader(name: $0.key, value: $0.value))
        }
    }
    
    lazy var session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = self.timeout
        return Session(configuration: configuration, interceptor: self)
    }()
}

extension SEBaseRequest: RequestInterceptor {

    public func adapt(_ urlRequest: URLRequest,
                      for session: Session,
                      completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(Result.success(urlRequest))
    }
    
    public func retry(_ request: Request,
                      for session: Session,
                      dueTo error: Error,
                      completion: @escaping (RetryResult) -> Void) {
        if ((error as NSError).code == -1001 || (error as NSError).code == 408) && retryCount < retry {
            retryCount += 1
            completion(.retry)
        } else {
            completion(.doNotRetry)
        }
    }
}
    
extension SEBaseRequest {
    
    open func perform(completion: @escaping ((T) -> Void)) -> Request {
        let request = session.request(path, method: method, parameters: body, encoding: encoding, headers: headers)
        
        setAuthenticate(request: request)
        execute(request: request, completion: completion)
        
        return request
    }
    
    open func upload(completion:@escaping ((T) -> Void)) -> Request {
        let request = session.upload(multipartFormData: { multipartFormData in
            if let images = self.images {
                for (name, image) in images {
                    if let imageData = image.jpegData(compressionQuality: 0.5) {
                        multipartFormData.append(imageData,
                                                 withName: name,
                                                 fileName: "\(name).jpeg",
                                                 mimeType: "image/jpeg")
                    }
                }
            }
            if let body = self.body as? [String: String] {
                for (key, value) in body {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
            }
        }, to: path,
           method: method,
           headers: headers)
        
        setAuthenticate(request: request)
        execute(request: request, completion: completion)

        return request
    }
    
    open func setAuthenticate(request: Alamofire.Request) {
        if let username = username, let password = password {
            request.authenticate(username: username, password: password)
            URLCache.shared.removeAllCachedResponses()
        }
    }
    
    func execute(request: DataRequest, completion: @escaping ((T) -> Void)) {
        switch responseType {
        case .JSON:
            request.responseJSON {
                self.execute(response: $0, completion: completion)
            }
        case .string:
            request.responseString {
                self.execute(response: $0, completion: completion)
            }
        case .data:
            request.responseData {
                self.execute(response: $0, completion: completion)
            }
        }
    }
    
    func execute<V>(response: AFDataResponse<V>, completion: @escaping ((T) -> Void)) {
        do {
            let result = try cast(response: response).result
            switch result {
            case .success(let data):
                completion(self.response.service(result: data, response: response.response))
            case .failure(let error):
                throw error
            }
        } catch {
            completion(self.response.service(error: error as NSError, response: response.response))
        }
    }
    
    func cast<V>(response: AFDataResponse<V>) throws -> AFDataResponse<U> {
        if let response = response as? AFDataResponse<U> {
            return response
        } else {
            throw NSError(domain: NSCocoaErrorDomain,
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
        }
    }
}
