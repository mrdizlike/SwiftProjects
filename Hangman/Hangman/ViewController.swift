//
//  ViewController.swift
//  Hangman
//
//  Created by Виктор on 23.02.2023.
//

import UIKit

class ViewController: UIViewController {

    var word: String!
    var usedLetters = [String]()
    var promptWord = ""
    var errorInt: Int!
    
    @IBOutlet var wordsLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var errorCounter: UILabel!
    var errorsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }

    @IBAction func submitButton(_ sender: UIButton) {
        if textField.text?.rangeOfCharacter(from: .letters) != nil{
            checkWord(textField.text!)
            
            errorInt -= 1
            errorCounter.text = "You have \(errorInt ?? 0) attempts!"
        } else {
            let ac = UIAlertController(title: "Warning!", message: "Please enter word", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
        
        if errorInt == 0 {
            resetGame("Oh no!", "Game over")
        }
        
        if !promptWord.contains("?"){
            resetGame("Good!", "You win!")
        }
    }
    
    func initUI(){
        if let Words = Bundle.main.url(forResource: "Words", withExtension: "txt"){
            if let WordsContents = try? String(contentsOf: Words){
                var lines = WordsContents.components(separatedBy: "\n")
                lines.shuffle()
                word = lines.first
            }
        }
        
        for _ in word {
            promptWord += "?"
        }
        
        errorInt = 10
        textField.text?.removeAll()
        wordsLabel.text = promptWord
        errorCounter.text = "You have \(errorInt ?? 0) attempts!"
    }
    
    func resetGame(_ title: String, _ message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Try again", style: .default))
        present(ac, animated: true)
        usedLetters.removeAll()
        promptWord.removeAll()
        initUI()
    }
    
    func checkWord(_ word: String){
        for wordLetters in word{
            let strLetter = String(wordLetters)
            usedLetters.append(strLetter)
            promptWord = ""
        }
        
        for letter in self.word {
            let strLetter = String(letter)

            if usedLetters.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
        wordsLabel.text = promptWord
        }
    }



