//
//  Photo.swift
//  PINREST
//
//  Created by Layana on 08/03/18.
//  Copyright © 2018 Experion. All rights reserved.
//

import UIKit

struct Photo {
    
    var caption: String
    var comment: String
    var image: UIImage
    var thumbnail: UIImage
    
    init(caption: String, comment: String, image: UIImage, tImage: UIImage) {
        self.caption = caption
        self.comment = comment
        self.image = image
        self.thumbnail = tImage
    }
    
    init?(dictionary: [String: String]) {
        guard let caption = dictionary["Caption"],
            let comment = dictionary["Comment"],
            let photo = dictionary["Photo"],
            let thumbnail = dictionary["TPhoto"],
            let image = UIImage(named: photo),
            let tImage = UIImage(named: thumbnail)
            else {
                return nil
            }
        self.init(caption: caption, comment: comment, image: image, tImage: tImage)
    }
    
    static func allPhotos() -> [Photo] {
        var photos = [Photo]()
        guard let URL = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
            let photosFromPlist = NSArray(contentsOf: URL) as? [[String:String]] else {
                return photos
        }
        for dictionary in photosFromPlist {
            if let photo = Photo(dictionary: dictionary) {
                photos.append(photo)
            }
        }
        return photos
    }
    
}

