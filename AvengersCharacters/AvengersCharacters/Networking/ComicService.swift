//
//  ComicService.swift
//  AvengersCharacters
//
//  Created by iMac Pro on 3/2/23.
//

import UIKit

struct ComicService {
    
    static func fetchComicList(offset: String, forAvenger avenger: Avenger, completion: @escaping (Result<ComicTopLevelDictionary, NetworkError>) -> Void ) {
//    https://gateway.marvel.com/v1/public/characters/1009175/comics?limit=50&offset=0&ts=1&apikey=68470b7b93879cefb8d99a7c5a5b6c0f&hash=2823b9ddec02040bbdd3b5a6ae2c70f9
        guard let baseURL = URL(string: Constants.AvengersURL.baseURL) else { completion(.failure(.invalidURL)) ; return }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path.append(contentsOf: "/\(avenger.avengerID)")
        urlComponents?.path.append(contentsOf: Constants.AvengersURL.comicPath)
        
        let limitQuery      = URLQueryItem(name: Constants.UrlQueryComponents.limitKey, value: Constants.UrlQueryComponents.limitValue)
        let offsetQuery     = URLQueryItem(name: Constants.UrlQueryComponents.offsetKey, value: offset)
        let timeStampQuery  = URLQueryItem(name: Constants.UrlQueryComponents.timeStampKey, value: Constants.UrlQueryComponents.timeStampValue)
        let apiQuery        = URLQueryItem(name: Constants.UrlQueryComponents.apiKeyKey, value: Constants.UrlQueryComponents.apiKeyValue)
        let hashQuery       = URLQueryItem(name: Constants.UrlQueryComponents.hashKey, value: Constants.UrlQueryComponents.hashValue)
        urlComponents?.queryItems = [limitQuery, offsetQuery, timeStampQuery, apiQuery, hashQuery]
        
        guard let finalURL = urlComponents?.url else { completion(.failure(.invalidURL)) ; return }
        print("fetchComicList Final URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("fetchComicList Response Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { completion(.failure(.noData)) ; return }
            do {
                let topLevel = try JSONDecoder().decode(ComicTopLevelDictionary.self, from: data)
                completion(.success(topLevel))
            } catch {
                completion(.failure(.unableToDecode))
                print("from fetchComicList data.")
            }
        }.resume()
    }
    
    
    static func fetchComicThumbnail(forComic comic: Comic, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let finalURL = URL(string: "\(comic.comicImage.imagePath).\(comic.comicImage.imageExtention)") else { completion(.failure(.invalidURL)) ; return }
        print("fetchComicImage Final URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { comicData, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("fetchComicImage Response Status Code: \(response.statusCode)")
            }
            
            guard let comicData = comicData else { completion(.failure(.noData)) ; return }
            
            guard let image = UIImage(data: comicData) else { completion(.failure(.unableToDecode)) ; return }
            completion(.success(image))
        }.resume()
    }
}
