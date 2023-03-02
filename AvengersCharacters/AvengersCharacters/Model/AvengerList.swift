//
//  AvengersListTopLevelDictionary.swift
//  AvengersCharacters
//
//  Created by iMac Pro on 3/1/23.
//

import Foundation

struct AvengersListTopLevelDictionary: Decodable {
    private enum CodingKeys: String, CodingKey {
        case listData = "data"
    }
    
    let listData: Results
}

struct Results: Decodable {
    private enum CodingKeys: String, CodingKey {
        case offset
        case listResults = "results"
    }
    
    let offset: Int
    let listResults: [Avenger]
}

struct Avenger: Decodable {
    private enum CodingKeys: String, CodingKey {
        case avengerID          = "id"
        case avengerName        = "name"
        case avengerDescription = "description"
        case avengerImage       = "thumbnail"
        case avengerURI         = "resourceURI"
        case avengerComics      = "comics"
    }
    
    let avengerID: Int
    let avengerName: String
    let avengerDescription: String
    let avengerImage: Thumbnail
    let avengerURI: String
    let avengerComics: Comics
}

struct Thumbnail: Decodable {
    private enum CodingKeys: String, CodingKey {
        case imagePath      = "path"
        case imageExtention = "extension"
    }
    
    let imagePath: String
    let imageExtention: String
}

struct Comics: Decodable {
    let available: Int
    let collectionURI: String
}
