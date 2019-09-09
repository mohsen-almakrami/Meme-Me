//
//  ViewImagesView Controller.swift
//  Meme Me
//
//  Created by Mohsen Almakrami on 09/09/2019.
//  Copyright © 2019 Mohsen Almakrami. All rights reserved.
//

import UIKit

struct Meme {
    let topText : String
    let bottomText : String
    let originalImage : UIImage
    let memedImage : UIImage
}


class ViewImagesViewController: UIViewController {

    
    // MARK: - Prop
    
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var shareButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var topLabelOutlet: UITextField!
    @IBOutlet weak var bottomLabelOutlet: UITextField!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var cameraButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var buttonImageView: NSLayoutConstraint!
    @IBOutlet weak var toolBarView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextField()
       SettingUpKeyboardNotifications()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButtonOutlet.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        if imageViewOutlet.image == nil {
            shareButtonOutlet.isEnabled = false
        }
        
    }
    
    

    // MARK: - IBActions
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        
        let shareView = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        shareView.popoverPresentationController?.sourceView = self.view
        
        self.present(shareView, animated: true) {
            self.save()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        imageViewOutlet.image = UIImage()
        topLabelOutlet.text = "TOP"
        bottomLabelOutlet.text = "BOTTOM"
        shareButtonOutlet.isEnabled = false
        
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        pickImage(sourceType: .camera)
        
    }
    
    @IBAction func albumButtonPressed(_ sender: Any) {
        
        pickImage(sourceType: .photoLibrary)
        
    }
    
    
    // MARK: - Model
    
    private func save() {
        let meme = Meme(topText: topLabelOutlet.text!, bottomText: bottomLabelOutlet.text!, originalImage: imageViewOutlet.image!, memedImage:generateMemedImage())
        
        
    }
    
    
    private func generateMemedImage() -> UIImage {
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        toolBarView.isHidden = true
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        toolBarView.isHidden = false
        
        return memedImage
    }
    
    
    // MARK: - Picker Image
    
    private func pickImage(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Text Field
    
    private func setupTextField() {
        
        topLabelOutlet.delegate = self
        bottomLabelOutlet.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}


// MARK: - Ext. Image Picker

extension ViewImagesViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage  {
           imageViewOutlet.image = image
            shareButtonOutlet.isEnabled = true
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Text Field Delegate

extension ViewImagesViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}



extension ViewImagesViewController {
    func SettingUpKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewImagesViewController.ShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewImagesViewController.Hidekeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func ShowKeyboard(notification : Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {[weak self] in
                self?.buttonImageView.constant += keyboardSize.height
                self?.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    @objc func Hidekeyboard(notification : Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {[weak self] in
                self?.buttonImageView.constant -= keyboardSize.height
                self?.view.layoutIfNeeded()
                }, completion: nil)
        }
}

}








