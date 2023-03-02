//
//  AvengerService.swift
//  AvengersCharacters
//
//  Created by iMac Pro on 3/1/23.
//

import UIKit

struct AvengerService {
    
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
                print("from fetchAvengerList data.")
            }
        }.resume()
    }
    
    
    static func fetchAvengerImage(forAvenger avenger: Avenger, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let finalURL = URL(string: "\(avenger.avengerImage.imagePath).\(avenger.avengerImage.imageExtention)") else { completion(.failure(.invalidURL)) ; return }
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
