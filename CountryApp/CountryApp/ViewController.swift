//
//  ViewController.swift
//  CountryApp
//
//  Created by Виктор on 10.03.2023.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [CountryJSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readJSON()
    }

    func readJSON(){
        do {
                if let filePath = Bundle.main.path(forResource: "output", ofType: "json") {
                    let fileUrl = URL(fileURLWithPath: filePath)
                    let data = try Data(contentsOf: fileUrl)
                    parse(json: data)
                }
            } catch {
                print("error: \(error)")
            }
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonCountries = try? decoder.decode(Countries.self, from: json){
            countries = jsonCountries.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.CountryName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "secondScreen") as? SecondScreenViewController{
            vc.detailItem = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

