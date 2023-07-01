//
//  SecondScreenViewController.swift
//  CountryApp
//
//  Created by Виктор on 10.03.2023.
//

import UIKit

class SecondScreenViewController: UIViewController {

    var detailItem: CountryJSON?
    @IBOutlet var countOfPeopleLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var factLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLabel()
    }
    

    func initLabel() {
        countOfPeopleLabel.text = "Количество населения: \(detailItem?.CountOfPeople ?? 0)"
        
        languageLabel.text = "Родной язык: \(detailItem?.Language ?? "")"
        
        capitalLabel.text = "Столица: \(detailItem?.Capital ?? "")"
        
        factLabel.text = "Факт: \(detailItem?.Fact ?? "")"
        
    }

}
