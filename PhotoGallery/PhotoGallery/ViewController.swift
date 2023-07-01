//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Виктор on 02.03.2023.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageCollection = [ImageInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath) as? Image else {
            fatalError("Unable to dequeue PersonCell")
        }
        
        let images = imageCollection[indexPath.item]
        
        cell.nameLabel.text = images.name
        
        let path = getDocumentsDirectory().appendingPathComponent(images.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = imageCollection[indexPath.item]
        
        let ac = UIAlertController(title: "What you want?", message: nil, preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "Remove", style: .default){
            [weak self] _ in
            self?.imageCollection.remove(at: indexPath.row)
            self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Change name", style: .default){
            [weak self] _ in
            let newAc = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
            newAc.addTextField()
            newAc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            newAc.addAction(UIAlertAction(title: "Done", style: .default){
                [weak self, weak newAc] _ in
                guard let newName = newAc?.textFields?[0].text else {return}
                image.name = newName
                
                self?.collectionView.reloadData()
            })
            self?.present(newAc, animated: true)
        })
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        
        let imageCell = ImageInfo(name: "Unknown", image: imageName)
        imageCollection.append(imageCell)
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func addNewImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

