//
//  ViewController.swift
//  Notes
//
//  Created by Виктор on 21.03.2023.
//

import UIKit

class ViewController: UITableViewController {

    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Создать", style: .plain, target: self, action: #selector(createNote))
        title = "dude"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.globalNoteArray = [Note]()
        
        if  let data = UserDefaults.standard.value(forKey: "noteArray") as? Data,
            let note = try? JSONDecoder().decode([Note].self, from: data) {
            appDelegate.globalNoteArray = note
            notes = note
            tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].noteName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "noteScreen") as? DetailViewController
        vc?.noteNameString = notes[indexPath.row].noteName
        vc?.noteTextString = notes[indexPath.row].noteText
        vc?.isEdit = true
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if  let data = UserDefaults.standard.value(forKey: "note") as? Data,
            let note = try? JSONDecoder().decode([Note].self, from: data) {
            notes = note
            print(notes.count)
            tableView.reloadData()
        }
        
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: "noteArray")
        }
    }

    @objc func createNote() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "noteScreen") as? DetailViewController
        vc?.isEdit = false
        navigationController?.pushViewController(vc!, animated: true)
    }

}

