//
//  AbstractFabric.swift
//  Patterns
//
//  Created by Виктор on 29.05.2023.
//

import UIKit
import Foundation

protocol Somebody {
    func getDiscription()
}

protocol AbstractFabric {
    func nameSomebody() -> Somebody
}
