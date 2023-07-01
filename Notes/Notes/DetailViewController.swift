//
//  DetailViewController.swift
//  Notes
//
//  Created by Виктор on 21.03.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var noteName: UITextField!
    @IBOutlet var noteText: UITextView!
    
    var noteNameString: String!
    var noteTextString: String!
    var isEdit: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteName.text = noteNameString
        noteText.text = noteTextString
        
        if isEdit {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteNote))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveNote))
        }
    }
    
    @objc func saveNote() {
        let dataNote = Note(noteName: noteName.text!, noteText: noteText.text!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.globalNoteArray?.append(dataNote)
        
        if let data = try? JSONEncoder().encode(appDelegate.globalNoteArray) {
            UserDefaults.standard.set(data, forKey: "note")
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func deleteNote() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        for i in 0 ..< appDelegate.globalNoteArray!.count {
            if appDelegate.globalNoteArray![i].noteName == noteNameString {
                appDelegate.globalNoteArray?.remove(at: i)
                print(appDelegate.globalNoteArray![i].noteName)
                
                if let data = try? JSONEncoder().encode(appDelegate.globalNoteArray) {
                    UserDefaults.standard.set(data, forKey: "note")
                    navigationController?.popViewController(animated: true)
                }
                break
            }
        }
    }


}
