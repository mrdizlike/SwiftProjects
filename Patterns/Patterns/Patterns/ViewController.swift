//
//  ViewController.swift
//  Patterns
//
//  Created by Виктор on 29.05.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

class SomeBody: Somebody {
    func getDiscription() {
        print("I'am somebody")
    }
}

class notSomeBody: Somebody {
    func getDiscription() {
        print("I'am notSomeBody")
    }
}

class somebodyFactory: AbstractFabric{
    func nameSomebody() -> Somebody {
        return notSomeBody()
    }
}


