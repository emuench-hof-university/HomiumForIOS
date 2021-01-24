//
//  ImagePickerDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 11.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //fields
    private let presenter: UIPresenterDelegate
    
    var onPictureSelected : (UIImage) -> Void = {_ in}
    
    //init
    init(presenter : UIPresenterDelegate){
        self.presenter = presenter
    }
    
    //functions
    func choosePictureFromGalery(){
        triggerImagePickerController(type: .photoLibrary)
    }
    
    func takePictureWithCamera(){
        triggerImagePickerController(type: .camera)
    }
    
    private func triggerImagePickerController(type: UIImagePickerController.SourceType){
        let imagePickerCntrl = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(type){
            imagePickerCntrl.allowsEditing = true
            imagePickerCntrl.sourceType = type
            imagePickerCntrl.delegate = self
            presenter.present(imagePickerCntrl, animated: true, completion: {
                print("completion of image picker controller")
            })
        }
        
        
    }
    
    //delegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            onPictureSelected(editedImage)
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            onPictureSelected(originalImage)
        }
        
        presenter.dismiss(animated: true, completion: nil)
    }
}
