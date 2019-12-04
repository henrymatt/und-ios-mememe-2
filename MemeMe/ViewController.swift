//
//  ViewController.swift
//  MemeMe
//
//  Created by Matt Henry on 12/2/19.
//  Copyright © 2019 Beardbird. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var takePictureButton: UIBarButtonItem!
    @IBOutlet weak var cancelMemeButton: UIBarButtonItem!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    var currentlyEditingTextField: UITextField?
    
    let defaultText = "ENTER TEXT"
    
    struct Meme {
        let topText: String
        let bottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
    }
    
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIBasedOnDeviceCapabilities()
        setUIForNoImageState()
        setMemeTextAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if (currentlyEditingTextField == bottomText) {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    
    // MARK: UI State
    
    func setUIForImageEditingState() {
        imageContainerView.isHidden = false
        shareMemeButton.isEnabled = true
        cancelMemeButton.isEnabled = true
    }
    
    func setUIForNoImageState() {
        imageContainerView.isHidden = true
        shareMemeButton.isEnabled = false
        cancelMemeButton.isEnabled = false
        imageView.image = nil
    }
    
    func setUIBasedOnDeviceCapabilities() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            takePictureButton.isEnabled = false
        }
    }
    
    func setMemeTextAttributes() {
        setMemeTextAttributesFor(textField: topText)
        setMemeTextAttributesFor(textField: bottomText)
    }
    
    func setMemeTextAttributesFor(textField: UITextField) {
        let memeParagaphAttributes = NSMutableParagraphStyle()
        memeParagaphAttributes.alignment = .center
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSAttributedString.Key.strokeWidth: -1.0,
            NSAttributedString.Key.paragraphStyle: memeParagaphAttributes
        ]
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    // MARK: ImagePicker Delegate Methods
    
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
    
    
    // MARK: TextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentlyEditingTextField = textField
        if textField.text == defaultText {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentlyEditingTextField = nil
        if (textField.text == "") {
            textField.text = defaultText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Main Actions
    
    @IBAction func choosePictureFromAlbum(_ sender: Any) {
        presentPickerControllerWith(sourceType: .savedPhotosAlbum)
    }
    
    @IBAction func takePictureFromCamera(_ sender: Any) {
        presentPickerControllerWith(sourceType: .camera)
    }
    
    func presentPickerControllerWith(sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func resetMeme() {
        setUIForNoImageState()
    }
    
    @IBAction func shareMeme() {
        let memedImage = generateMemedImage()
        let activityView = UIActivityViewController.init(activityItems: [memedImage], applicationActivities: nil)
        activityView.completionWithItemsHandler = { (activity, success, items, error) in
            if (success) {
                self.saveMeme(memedImage)
            }
        }
        present(activityView, animated: true)
    }
    
    func generateMemedImage() -> UIImage {
        toolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbar.isHidden = false
        
        return memedImage
    }
    
    func saveMeme(_ memedImage: UIImage) {
        //let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
        //commenting out because we don't actually do anything with this meme
        print("Saved the meme")
    }
    
    
    // MARK: Notifications Setup/Teardown
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

