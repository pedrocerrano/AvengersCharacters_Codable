//
//  AvengerService.swift
//  AvengersCharacters
//
//  Created by iMac Pro on 3/1/23.
//

import UIKit

struct AvengerService {
    
// REFERENCE URL: https://gateway.marvel.com/v1/public/characters?limit=100&offset=0&ts=1&apikey=68470b7b93879cefb8d99a7c5a5b6c0f&hash=2823b9ddec02040bbdd3b5a6ae2c70f9
    static func fetchAvengerList(paginationOffset offset: String, completion: @escaping (Result<AvengersListTopLevelDictionary, NetworkError>) -> Void) {
        guard let baseURL = URL(string: Constants.AvengersURL.baseURL) else { completion(.failure(.invalidURL)) ; return }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let limitQuery      = URLQueryItem(name: Constants.UrlQueryComponents.limitKey, value: Constants.UrlQueryComponents.limitValue)
        let offsetQuery     = URLQueryItem(name: Constants.UrlQueryComponents.offsetKey, value: offset)
        let timeStampQuery  = URLQueryItem(name: Constants.UrlQueryComponents.timeStampKey, value: Constants.UrlQueryComponents.timeStampValue)
        let apiQuery        = URLQueryItem(name: Constants.UrlQueryComponents.apiKeyKey, value: Constants.UrlQueryComponents.apiKeyValue)
        let hashQuery       = URLQueryItem(name: Constants.UrlQueryComponents.hashKey, value: Constants.UrlQueryComponents.hashValue)
        urlComponents?.queryItems = [limitQuery, offsetQuery, timeStampQuery, apiQuery, hashQuery]
        
        guard let finalURL = urlComponents?.url else { completion(.failure(.invalidURL)) ; return }
        print("fetchAvengerList Final URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("fetchAvengerList Response Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { completion(.failure(.noData)) ; return }
            do {
                let topLevel = try JSONDecoder().decode(AvengersListTopLevelDictionary.self, from: data)
                completion(.success(topLevel))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    
    static func fetchAvenger(forAvenger avenger: Avenger, completion: @escaping (Result<Avenger, NetworkError>) -> Void) {
        guard let baseURL = URL(string: Constants.AvengersURL.baseURL) else { completion(.failure(.invalidURL)) ; return }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path.append("/\(avenger.avengerID)")
        
        let timeStampQuery  = URLQueryItem(name: Constants.UrlQueryComponents.timeStampKey, value: Constants.UrlQueryComponents.timeStampValue)
        let apiQuery        = URLQueryItem(name: Constants.UrlQueryComponents.apiKeyKey, value: Constants.UrlQueryComponents.apiKeyValue)
        let hashQuery       = URLQueryItem(name: Constants.UrlQueryComponents.hashKey, value: Constants.UrlQueryComponents.hashValue)
        urlComponents?.queryItems = [timeStampQuery, apiQuery, hashQuery]
        
        guard let finalURL = urlComponents?.url else { completion(.failure(.invalidURL)) ; return }
        print("fetchAvenger Final URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("fetchAvenger Response Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { completion(.failure(.noData)) ; return }
            do {
                let topLevel = try JSONDecoder().decode(AvengersListTopLevelDictionary.self, from: data)
                if let avenger = topLevel.data.results.first {
                    completion(.success(avenger))
                } else {
                    completion(.failure(.emptyArray))
                    return
                }
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    
    static func fetchAvengerImage(forAvenger avenger: Avenger, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let finalURL = URL(string: "\(avenger.avengerImage.path).\(avenger.avengerImage.imageExtention)") else { completion(.failure(.invalidURL)) ; return }
        print("fetchAvengerImage Final URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("fetchAvengerImage Response Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { completion(.failure(.noData)) ; return }
            
            guard let image = UIImage(data: data) else { completion(.failure(.unableToDecode)) ; return }
            completion(.success(image))
            
        }.resume()
    }
    
}
