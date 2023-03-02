//
//  Constants.swift
//  AvengersCharacters
//
//  Created by iMac Pro on 3/1/23.
//

import Foundation

struct Constants {

    struct AvengersURL {
        static let baseURL          = "https://gateway.marvel.com/v1/public/characters"
        static let comicPath        = "/comics"
    }
    
    struct UrlQueryComponents {
        static let limitKey         = "limit"
        static let limitValue       = "100"
        static let offsetKey        = "offset"
        
        static let timeStampKey     = "ts"
        static let timeStampValue   = "1"
        static let apiKeyKey        = "apikey"
        static let apiKeyValue      = "68470b7b93879cefb8d99a7c5a5b6c0f"
        static let hashKey          = "hash"
        static let hashValue        = "2823b9ddec02040bbdd3b5a6ae2c70f9"
    }
    
    struct Error {
        static let unknownError     = "Unknown error. You guess is as good as mine."
    }
}
