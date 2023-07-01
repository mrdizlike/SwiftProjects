//
//  UserModel.swift
//  MVC template
//
//  Created by Виктор on 15.03.2023.
//
// Это у нас Модель

import UIKit

class User {
    var firstName: String
    var secondName: String
    var age: Int
    
    init(firstName: String, secondName: String, age: Int) {
        self.firstName = firstName
        self.secondName = secondName
        self.age = age
    }
}

protocol UserPrototype {
    func findFirstName() -> String
    func findSecondName() -> String
    func findAge() -> Int
}
