//
//  Controller.swift
//  MVC template
//
//  Created by Виктор on 15.03.2023.
//
// это у нас контроллер

import UIKit

class UserService {
    var userRepository: UserPrototype
    
    init(userRepository: UserPrototype) {
        self.userRepository = userRepository
    }
    
    func getUserFirstName(){
        userRepository.findFirstName()
    }
    
    func getUserSecondName(){
        userRepository.findFirstName()
    }
    
    func getUserAge(){
        userRepository.findAge()
    }
}

class UserPrototypeTmpl: UserPrototype {
    var users = [User]()
    
    func findFirstName() -> String {
        return users.first?.firstName ?? ""
    }
    
    func findSecondName() -> String {
        return users.first?.secondName ?? ""
    }
    
    func findAge() -> Int {
        return users.first?.age ?? 0
    }
    
    
}
