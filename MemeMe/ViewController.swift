//
//  ViewController.swift
//  MemeMe
//
//  Created by Matt Henry on 12/2/19.
//  Copyright © 2019 Beardbird. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var displayImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteImageButton: UIButton!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    let defaultText = "ENTER TEXT"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyDeviceCanTakePictures()
        setUIForNoImageState()
        setUpTextFields()
    }
    
    func setUIForImageEditingState() {
        displayImageView.isHidden = false
        deleteImageButton.isHidden = false
    }
    
    func setUIForNoImageState() {
        displayImageView.isHidden = true
        deleteImageButton.isHidden = true
        imageView.image = nil
    }
    
    func setUpTextFields() {
        let memeParagaphAttributes = NSMutableParagraphStyle()
        memeParagaphAttributes.alignment = .center
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -1.0,
            NSAttributedString.Key.paragraphStyle: memeParagaphAttributes
        ]
        
        topText.delegate = self
        bottomText.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.text = defaultText
        bottomText.text = defaultText
    }
    
    func verifyDeviceCanTakePictures() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // TODO: Nothing?
        } else {
            takePictureButton.isEnabled = false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            setUIForImageEditingState()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == defaultText {
            textField.text = ""
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text == "") {
            textField.text = defaultText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func choosePicture(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .savedPhotosAlbum
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func deleteImage() {
        setUIForNoImageState()
    }


}

