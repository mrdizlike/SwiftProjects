//
//  ViewController.swift
//  Project6
//
//  Created by Виктор on 18.02.2023.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var wordFilter = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(releaseCredits))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(promptWordFilter))
        
        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
            }
            self.showError()
        }
    }
    
    
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func showError(){
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading Error", message: "Some error", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }

    @objc func releaseCredits(){
        let ac = UIAlertController(title: "Credits", message: "Hi! This data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        let Button = UIAlertAction(title: "Ok", style: .default)
        ac.addAction(Button)
        present(ac, animated: true)
    }
    
    @objc func promptWordFilter(){
        let ac = UIAlertController(title: "Input word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitButton = UIAlertAction(title: "Search", style: .default){
            [weak self, weak ac] _ in
            guard let word = ac?.textFields?[0].text else {return}
            self?.Submit(word)
        }
        
        ac.addAction(submitButton)
        present(ac, animated: true)
    }
    
    func Submit(_ word: String){
        for petition in petitions {
            if word == petition.body
            {
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

