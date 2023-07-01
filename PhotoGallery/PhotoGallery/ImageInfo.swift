//
//  ImageInfo.swift
//  PhotoGallery
//
//  Created by Виктор on 02.03.2023.
//

import UIKit

class ImageInfo: NSObject {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
