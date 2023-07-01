//
//  ViewController.swift
//  MVC template
//
//  Created by Виктор on 15.03.2023.
//
// это у нас View

import UIKit

class ViewController: UIViewController {

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SomeCell", for: indexPath)
        let user = users[indexPath.row]
        let userPrototype = UserPrototypeTmpl()
        user.firstName = userPrototype.findFirstName()
        cell.textLabel?.text = user.firstName
        return cell
    }
}

