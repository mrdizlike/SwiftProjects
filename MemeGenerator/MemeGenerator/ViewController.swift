//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Виктор on 03.04.2023.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func loadPhoto(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func inputTopText(_ sender: Any) {
        let ac = UIAlertController(title: "Input text", message: nil, preferredStyle: .alert)
        ac.addTextField { textfield in
            textfield.placeholder = "Some meme"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) {
            [self, weak ac] _ in
            guard let ac = ac, let textField = ac.textFields?.first else { return }
            ACinputTopText(someText: textField.text!)
        }
        ac.addAction(confirmAction)
        present(ac, animated: true)
    }
    
    func ACinputTopText(someText: String) {
        let text = someText
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 120)!

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(imageView.image!.size, false, scale)

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        imageView.image!.draw(in: CGRect(origin: CGPoint.zero, size: imageView.image!.size))

        let rect = CGRect(origin: CGPoint(x: 450, y: 0), size: imageView.image!.size)
        text.draw(in: rect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = newImage
    }
    
    @IBAction func inputBottomText(_ sender: Any) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
        }
    }
    
}

