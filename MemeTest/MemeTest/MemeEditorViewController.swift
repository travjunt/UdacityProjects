//
//  MemeEditorViewController.swift
//  MemeTest
//
//  Created by Travis McCormick on 6/30/17.
//  Copyright © 2017 TravisMcCormick. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

	var meme = [Meme]()
	
  // MARK: - IB Outlets
  
  @IBOutlet weak var imagePickerView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var albumButton: UIBarButtonItem!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var navBar: UINavigationBar!
  @IBOutlet weak var toolBar: UIToolbar!
  @IBOutlet weak var shareButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    topTextField.delegate = self
    bottomTextField.delegate = self
    cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    configureTextField(textField: topTextField)
    configureTextField(textField: bottomTextField)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    self.subscribeToKeyboardNotifications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    
    super.viewWillDisappear(animated)
    self.unsubscribeFromKeyboardNotifications()
  }
  
  // MARK: - Configure Text Fields
  
  func configureTextField(textField: UITextField) {
    textField.defaultTextAttributes = memeTextAttributes
    textField.textAlignment = .center
    textField.enablesReturnKeyAutomatically = true
    topTextField.text = "TOP"
    bottomTextField.text = "BOTTOM"
  }
  
  //  MARK: - Pick image from Album or Camera
  
  func pickImageSource(sourceType: UIImagePickerControllerSourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = sourceType
    present(imagePicker, animated: true, completion: nil)
  }

  @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
    pickImageSource(sourceType: .photoLibrary)
  }
  
  @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
    pickImageSource(sourceType: .camera)
  }
  
  
  //  Handle when picking image is cancelled
  func imagePickerControllerDidCancel(_: UIImagePickerController) {
    
    dismiss(animated: true, completion: nil)
  }

  //  Place selected photo in UIImage View
  func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo: [String : Any]) {
    dismiss(animated: true, completion: nil)
    if let image = didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] as? UIImage {
      imagePickerView.image = image
    }
  }
  
  //  MARK: - Text Attributes
  
  let memeTextAttributes:[String:Any] = [
    NSStrokeColorAttributeName: UIColor.black,
    NSForegroundColorAttributeName: UIColor.white,
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName: -3.0,]
  
  // MARK: - Create Meme, Save and Share
  
  func generateMemedImage() -> UIImage {
    
    navBar.isHidden = true
    toolBar.isHidden = true
    
    // Render view to an image
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
    let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    navBar.isHidden = false
    toolBar.isHidden = false
	
    return memedImage
  }
  
  func save() {
	
	let meme = Meme.init(
		topTextField: topTextField.text!,
		bottomTextField: bottomTextField.text!,
		originalImage: imagePickerView.image!,
	    memedImage: generateMemedImage())
	
	let object = UIApplication.shared.delegate
	let appDelegate = object as! AppDelegate
	
	appDelegate.memes.append(meme)
	
  }
	
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
      let memedImage = generateMemedImage()
      let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
      nextController.completionWithItemsHandler = { activity, success, items, error in
      
        if(success) {
		  self.save()
          self.dismiss(animated: true, completion: nil)
        }
      }
      self.present(nextController, animated: true, completion: nil)
  }
	
  //  MARK: - Keyboard Will Show/Hide
  
  func getKeyboardHeight(_ notification:Notification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.cgRectValue.height
  }
  
  func keyboardWillShow(_ notification:Notification) {
    if bottomTextField.isFirstResponder {
      self.view.frame.origin.y -= getKeyboardHeight((notification as NSNotification) as Notification)
    }
  }
  
  func keyboardWillHide(_ notification: Notification) {
    if bottomTextField.resignFirstResponder() {
      self.view.frame.origin.y += getKeyboardHeight((notification as NSNotification) as Notification)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    textField.resignFirstResponder()
    return true
  }

  // MARK: - Subscribe/Unsubscribe to Notifications
  
  func subscribeToKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
  }
  
  func unsubscribeFromKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
  }
}

