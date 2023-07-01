//
//  ViewController.swift
//  ShoppingList
//
//  Created by Виктор on 16.02.2023.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitUI()
    }

    func InitUI(){
        title = "ShoppingApp"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShopItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
        
        tableView.reloadData()
    }
    
    func Submit(_ answer: String){
        shoppingList.insert(answer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    @objc func addShopItem(){
        let ac = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.Submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func clearList(){
        shoppingList.removeAll()
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
}

