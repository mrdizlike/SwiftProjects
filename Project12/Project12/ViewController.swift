//
//  ViewController.swift
//  Project12
//
//  Created by Виктор on 04.03.2023.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var slider: UISlider!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var filterButton: UIButton!
    
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    }

    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Save error", message: "Where image?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_: didFinishSavingWithError:contextInfo:)), nil)
        
        print(image)
    }
    
    @IBAction func changeFIlter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved", message: "Image saved", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        if imageView.image == nil {
            let ac = UIAlertController(title: "Save error", message: "Where image?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(slider.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(slider.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(slider.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else {return}
        
        guard let actionTitle = action.title else {return}
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        filterButton.setTitle(actionTitle, for: .normal)
        
        applyProcessing()
    }
}

