//
//  Petition.swift
//  Project6
//
//  Created by Виктор on 18.02.2023.
//
import UIKit

struct Petition: Codable{
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable{
    var results: [Petition]
}
