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
    private let baseUrlConstructor: URLComponents = {
        var baseURLComponetns = URLComponents()
        baseURLComponetns.scheme = "https"
        baseURLComponetns.host = "raw.githubusercontent.com"
        return baseURLComponetns
    }()
    private let baseImageUrlConstructor: URLComponents = {
        var baseURLComponetns = URLComponents()
        baseURLComponetns.scheme = "https"
        baseURLComponetns.host = "github.com"
        return baseURLComponetns
    }()
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    private enum RequestType {
        case listRequest
        case hotelDetail
        case imageRequest
    }
    
    private func configureURL(requestType: RequestType, requestID: String? = nil) -> URL? {
        switch requestType {
        case .listRequest:
            var urlConstructor = baseUrlConstructor
            urlConstructor.path = "/iMofas/ios-android-test/master/0777.json"
            let url = urlConstructor.url
            return url
        case .hotelDetail:
            var urlConstructor = baseUrlConstructor
            guard let hotelID = requestID else { return nil }
            urlConstructor.path = "/iMofas/ios-android-test/master/\(hotelID).json"
            let url = urlConstructor.url
            return url
        case .imageRequest:
            var urlConstructor = baseImageUrlConstructor
            guard let imageID = requestID else { return nil }
            urlConstructor.path = "/iMofas/ios-android-test/raw/master/\(imageID)"
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
            if error != nil {
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
            } else {
                completion?(.failure(.somethingWrong))
                return
            }
        }
        task.resume()
    }
    
    func getHotelDetails(
        for hotelID: Int,
        completion: ((Result<HotelDetails, NetworkError>) -> Void)?) {
            guard let url = configureURL(requestType: .hotelDetail, requestID: String(hotelID)) else {
                print("URL Error!")
                return
            }
            let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            let urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 0)
            let task = session.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    completion?(.failure(.somethingWrong))
                    return
                }
                if let recievedData = data,
                   let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 {
                    do {
                        let json = try JSONDecoder().decode(HotelDetails.self, from: recievedData)
                        completion?(.success(json))
                    } catch {
                        completion?(.failure(.somethingWrong))
                    }
                } else {
                    completion?(.failure(.somethingWrong))
                    return
                }
            }
            task.resume()
        }
    
    func getImage(
        for imageAdress: String,
        completion: ((Result<Data, NetworkError>) -> Void)?
    ) {
        guard let url = configureURL(requestType: .imageRequest, requestID: imageAdress) else {
            print("URL Error!")
            return
        }
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        let urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 0)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion?(.failure(.somethingWrong))
                return
            }
            if let recievedData = data,
               let statusCode = (response as? HTTPURLResponse)?.statusCode,
                200..<300 ~= statusCode {
                completion?(.success(recievedData))
            } else {
                completion?(.failure(.somethingWrong))
                return
            }
        }
        task.resume()
    }
}
