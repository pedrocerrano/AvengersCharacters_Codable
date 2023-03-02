//
//  AvengersListTopLevelDictionary.swift
//  AvengersCharacters
//
//  Created by iMac Pro on 3/1/23.
//

import Foundation

struct AvengersListTopLevelDictionary: Decodable {
    let data: Results
}

struct Results: Decodable {
    let offset: Int
    let results: [Avenger]
}

struct Avenger: Decodable {
    private enum CodingKeys: String, CodingKey {
        case avengerID      = "id"
        case avengerName    = "name"
        case avengerImage   = "thumbnail"
        case avengerURI     = "resourceURI"
        case avengerComics  = "comics"
    }
    
    let avengerID: Int
    let avengerName: String
    let avengerImage: Thumbnail
    let avengerURI: String
    let avengerComics: Comics
}

struct Thumbnail: Decodable {
    private enum CodingKeys: String, CodingKey {
        case path
        case imageExtention = "extension"
    }
    
    let path: String
    let imageExtention: String
}

struct Comics: Decodable {
    let available: Int
    let collectionURI: String
}
