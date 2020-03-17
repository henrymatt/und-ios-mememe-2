//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Matt Henry on 3/17/20.
//  Copyright © 2020 Beardbird. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme?
    @IBOutlet weak var memeImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = meme?.memedImage
    }
}
