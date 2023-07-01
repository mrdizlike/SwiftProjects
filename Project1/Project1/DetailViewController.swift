//
//  DetailViewController.swift
//  Project1
//
//  Created by Виктор on 03.02.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var countOfViewLabel: UILabel!
    var selectedImage: String?
    var selectedPictureNumber = 0
    var totalPictures = 0
    var countOfView = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Изображение \(selectedPictureNumber) из \(totalPictures)"
        countOfViewLabel?.text = "You see'd pictures \(countOfView ?? 0) times"
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage{
            ImageView.image = UIImage(named: imageToLoad)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
}
