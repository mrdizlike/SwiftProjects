//
//  CountryJSON.swift
//  CountryApp
//
//  Created by Виктор on 10.03.2023.
//

import UIKit

struct CountryJSON: Codable {
    
    var CountryName: String
    var CountOfPeople: Int
    var Language: String
    var Capital: String
    var Fact: String
}

struct Countries: Codable {
    var results: [CountryJSON]
}
