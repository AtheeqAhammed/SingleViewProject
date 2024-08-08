//
//  Extension+ViewController.swift
//  SingleViewProject
//
//  Created by Ateeq Ahmed on 08/08/24.
//

import UIKit

extension ViewController: UIImagePickerControllerDelegate {
    
    @objc func attachFilesButtonTapped() {
        
        
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let OpenGalleryButton: UIAlertAction = UIAlertAction(title: "Open Gallary", style: .default)
        { action -> Void in
            //            print("Open Gallery")
            DispatchQueue.main.async {
                self.openGallery()
            }
        }
        let OpenCameraButton: UIAlertAction = UIAlertAction(title: "Open Camera", style: .default)
        { action -> Void in
            //            print("Open Camera")
            DispatchQueue.main.async {
                self.openCamera()
            }
        }

        let cancelButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        { action -> Void in
            print("Cancelled")
        }
        alert.addAction(OpenGalleryButton)
        alert.addAction(OpenCameraButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let controller = UIImagePickerController()
            controller.sourceType = .photoLibrary
            controller.allowsEditing = false
            if let aLibrary = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                controller.mediaTypes = aLibrary
            }
            controller.delegate = self
            present(controller, animated: true) {() -> Void in }
        }
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let controller = UIImagePickerController()
            controller.sourceType = .camera
            controller.allowsEditing = false
            if let aCamera = UIImagePickerController.availableMediaTypes(for: .camera) {
                controller.mediaTypes = aCamera
            }
            controller.delegate = self
            present(controller, animated: true) {() -> Void in }
        }
    }
}
