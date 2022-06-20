//
//  CameraVC.swift
//  Instagram
//
//  Created by Hamza on 2/21/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage
import FirebaseFirestore

class CameraVC: UIViewController {
    
    private let addImg: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "camera")
        imageView.backgroundColor = .gray
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let addBtn: UIButton = {
       let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.6)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(addImg)
        view.addSubview(addBtn)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        addImg.isUserInteractionEnabled = true
        addImg.addGestureRecognizer(tap)
        guard let imageData = addImg.image?.jpegData(compressionQuality: 0.2) else { return }
        addBtn.addTarget(self, action: #selector(addNew), for: .touchUpInside)
        
        print(imageData)
        
        
    }
    
    @objc func addNew() {
        
    }
    
    
    
    @objc func imgTapped(_ tap: UITapGestureRecognizer) {
        launchImgPicker()
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addImg.frame = CGRect(x: (view.width-200)/2, y: (view.height-250)/2, width: 200, height: 250)
        
        addBtn.frame = CGRect(x: (view.width-100)/2, y: addImg.bottom+50, width: 100, height: 50)
    }
    
    func uploadImageThenDocument() {
        
        guard let image = addImg.image
            else {
                simpleAlert(title: "Missing Fields", msg: "Please fill out all required field.")
                return
        }
        
        
        // Step 1: Turn the image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        // Step 2: Create an storage image reference -> A location in Firestorage for it to be stored.
        let imageRef = Storage.storage().reference().child("/Images/image.jpg")
        
        // Step 3: Set the meta Data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        // Step 4: Upload the data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image.")
                return
            }
            
            // Step 5: Once the image is uploaded retrieve the download URL
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to download url.")
                    return
                }
                
                guard let url = url else { return }
                
                
                
                // Step 6: Upload new Category document to the Firestore categories collection
                
            //    self.uploadDocument(url: url.absoluteString)
                
            })
        }
    }
    
 /*   func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var product = Product.init(name: productName,
                                   id: "",
                                   category: selectedCategory.id,
                                   price: price,
                                   productDescription: productDescription,
                                   imageUrl: url)
        
        
        if let producToEdit = productToEdit {
            // We are editing
            docRef = Firestore.firestore().collection("products").document(producToEdit.id)
            product.id = producToEdit.id
        } else {
            // New Category
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        
        
        let data = Product.modelToData(product: product)
        
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload new product to Firestore")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    */
    func handleError(error: Error, msg: String){
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
    }
    
}


extension CameraVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        addImg.contentMode = .scaleAspectFill
        addImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

