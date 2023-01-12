//
//  NetworkHandler.swift
//  CPTest
//
//  Created by Dmitrii Diadiushkin on 09.01.2023.
//

import Foundation

enum NetworkError: Error {
    case somethingWrong
}

final class NetworkHandler: NetworkHandlerProtocol {
    
//    static let shared = NetworkHandler()
//    private init() {}
    
    private let baseUrlConstructor: URLComponents = {
        var baseURLComponetns = URLComponents()
        baseURLComponetns.scheme = "https"
        baseURLComponetns.host = "raw.githubusercontent.com"
        return baseURLComponetns
    }()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    private enum RequestType {
        case listRequest
        case charDetail
    }
    
    private func configureURL(requestType: RequestType, charID: Int? = nil) -> URL? {
        switch requestType {
        case .listRequest:
            var urlConstructor = baseUrlConstructor
            urlConstructor.path = "/iMofas/ios-android-test/master/0777.json"
            let url = urlConstructor.url
            
            return url
        case .charDetail:
            var urlConstructor = baseUrlConstructor
            urlConstructor.path = "/iMofas/ios-android-test/master/0777.json"
            let url = urlConstructor.url
            
            return url
        }
    }
    
    func getHotelList(completion: ((Swift.Result<[HotelList], NetworkError>) -> Void)? = nil) {
        guard let url = configureURL(requestType: .listRequest) else {
            print("URL Error!")
            return
        }
        
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        
        let urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 0)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let _ = error {
                completion?(.failure(.somethingWrong))
                return
            }
            if let recievedData = data,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
                do {
                    let json = try JSONDecoder().decode([HotelList].self, from: recievedData)
                    completion?(.success(json))
                } catch {
                    completion?(.failure(.somethingWrong))
                }
            }
            else {
                completion?(.failure(.somethingWrong))
                return
                
            }
        }
        task.resume()
    }
}
