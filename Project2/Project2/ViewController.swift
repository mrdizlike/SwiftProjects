//
//  ViewController.swift
//  Project2
//
//  Created by Виктор on 04.02.2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var Button1: UIButton!
    @IBOutlet var Button2: UIButton!
    @IBOutlet var Button3: UIButton!
    
    var countries = [String]()
    var correctAnswer = 0
    var answerCount = 0
    var score = 0
    var highestScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificate()
        
        Button1.layer.borderWidth = 1
        Button2.layer.borderWidth = 1
        Button3.layer.borderWidth = 1
        
        Button1.layer.borderColor = UIColor.lightGray.cgColor
        Button2.layer.borderColor = UIColor.lightGray.cgColor
        Button3.layer.borderColor = UIColor.lightGray.cgColor
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        askQuestion()
        
        let defaults = UserDefaults.standard
        
        if let savedScore = defaults.object(forKey: "score") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                highestScore = try jsonDecoder.decode(Int.self, from: savedScore)
            } catch {
                print("Failed to load score")
            }
        }
    }

    func askQuestion(action: UIAlertAction! = nil){
        countries.shuffle()
        
        Button1.setImage(UIImage(named: countries[0]), for: .normal)
        Button2.setImage(UIImage(named: countries[1]), for: .normal)
        Button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased() + "|Score: \(score)"
    }
    
    func notificate() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Let's go to play!"
        content.title = "It's time to solve a task"
        content.categoryIdentifier = "task"
        content.userInfo = ["customData": "task"]
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    @IBAction func ButtonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag])"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
        
        if(answerCount == 10){
            ac.message = "Your final score is \(score)!"
            
            if score > highestScore {
                ac.message = "Woah! You have new highest score: \(score)"
                highestScore = score
                save()
            }
        }
        
        answerCount += 1
        print(answerCount)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedScore = try? jsonEncoder.encode(highestScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedScore,forKey: "score")
        } else {
            print("Failed to save score")
        }
    }
}

