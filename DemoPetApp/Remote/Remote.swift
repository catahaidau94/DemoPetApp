//
//  Remote.swift
//  DemoPetApp
//
//  Created by Catalin Haidau on 09.11.2023.
//

import Foundation
import RxCocoa
import RxSwift

enum ServiceError: Error {
    case cannotParse
    case invalidURL
}

final class Remote {

    private let endPoint: String

    init(_ endPoint: String) {
        self.endPoint = endPoint
    }
    
    // NonRx
    func getAuthToken(_ path: String, completion: @escaping (Result<Token, Error>) -> ()) {
        guard let url = URL(string: "\(endPoint)/\(path)") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        guard let clientId = Bundle.main.infoDictionary?["CLIENT_ID"] as? String,
              let clientSecret = Bundle.main.infoDictionary?["CLIENT_SECRET"] as? String else {
            completion(.failure(ServiceError.invalidURL)) // could be mapped to different error
            return
        }
        
        let httpBodyString = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)"
        guard let httpBody = httpBodyString.data(using: .utf8) else {
            completion(.failure(ServiceError.invalidURL)) // could be mapped to different error
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(Token.self, from: data)
                    completion(.success(result))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    // Rx
    func getItems(_ path: String) -> Observable<[Animal]> {
        guard let url = URL(string: "\(endPoint)/\(path)") else {
            return .error(ServiceError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(TokenManager.shared.accessToken)"]
        
        return URLSession.shared.rx
            .data(request: request)
            .flatMap { data -> Observable<[Animal]> in
                do {
                    let animals = try JSONDecoder().decode(AnimalsResponse.self, from: data)
                    return .just(animals.animals)
                } catch {
                    return .error(ServiceError.cannotParse)
                }
            }
    }

    func getItem(_ path: String, itemId: Int) -> Observable<Animal> {
        let absolutePath = "\(endPoint)/\(path)/\(itemId)"
        guard let url = URL(string: absolutePath) else {
            return .error(ServiceError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(TokenManager.shared.accessToken)"]
        
        return URLSession.shared.rx
            .data(request: request)
            .flatMap { data -> Observable<Animal> in
                do {
                    let animal = try JSONDecoder().decode(AnimalDetailsResponse.self, from: data)
                    return .just(animal.animal)
                } catch {
                    return .error(ServiceError.cannotParse)
                }
            }
    }
}

struct AnimalDetailsResponse: Codable {
    let animal: Animal
}

struct AnimalsResponse: Codable {
    let animals: [Animal]
}
