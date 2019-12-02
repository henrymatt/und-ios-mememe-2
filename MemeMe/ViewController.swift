//
//  ViewController.swift
//  MemeMe
//
//  Created by Matt Henry on 12/2/19.
//  Copyright © 2019 Beardbird. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var takePictureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyDeviceCanTakePictures()
    }
    
    func verifyDeviceCanTakePictures() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // TODO: Nothing?
        } else {
            takePictureButton.isEnabled = false
        }
    }
    
    
    @IBAction func choosePicture(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .savedPhotosAlbum
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }


}

