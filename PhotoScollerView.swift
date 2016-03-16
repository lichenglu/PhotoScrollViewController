//
//  PhotoScollerView.swift
//  ImageScroller
//
//  Created by chenglu li on 15/3/2016.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class PhotoScrollerView: PhotoScrollViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.imageView.image = UIImage(named: "testImage.jpg")
    }
    
}
