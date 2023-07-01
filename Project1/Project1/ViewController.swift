//
//  ViewController.swift
//  Project1
//
//  Created by Виктор on 03.02.2023.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]() //массив содержит в себе названия картинок
    var countOfView: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default //константа для работы с файлами
        let path = Bundle.main.resourcePath! //путь в бандле
        let items = try! fm.contentsOfDirectory(atPath: path) //файлы по этому пути
        let defaults = UserDefaults.standard

        
        DispatchQueue.global(qos: .userInteractive).async {
            for item in items {
                if item.hasPrefix("nssl")
                {
                    self.pictures.append(item) //добавляем файлы с префиксом nssl в массив pictures
                }
            }
        }
        
        if let savedCount = defaults.object(forKey: "countOfView") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                countOfView = try jsonDecoder.decode(Int.self, from: savedCount)
            } catch {
                print("Failed to load Data")
            }
        }
        
        pictures.sort()
        print(pictures)
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: пытаемся загрузить Detail сториборд и затайпкастить (приведение типа) его к DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
            countOfView += 1
            vc.countOfView = countOfView
            save()
        }
    }

    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(countOfView) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "countOfView")
        } else {
            print("Failed to save Data")
        }
    }

}

