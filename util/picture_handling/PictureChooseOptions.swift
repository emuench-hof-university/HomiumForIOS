//
//  PictureChooseOptions.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 11.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

enum PictureChooseOptions: CaseIterable, CustomStringConvertible{
    //cases
    case TAKE_PICTURE_WITH_CAMERA
    case CHOOSE_PICTURE_FROM_GALLERY
    case REMOVE_PICTURE
    
    //description
    var description: String{
        get{
            switch self{
                case .REMOVE_PICTURE: return ESSENTIAL_PHRASE_REMOVE_PICTURE
                case .CHOOSE_PICTURE_FROM_GALLERY: return ESSENTIAL_PHRASE_CHOOSE_PICTURE_FROM_GALLERY
                case .TAKE_PICTURE_WITH_CAMERA: return ESSENTIAL_PHRASE_TAKE_PICTURE_WITH_CAMERA
            }
        }
    }
    
    static func getAllAvalibleCases() -> [PictureChooseOptions]{
        var result = [PictureChooseOptions]()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            result.append(TAKE_PICTURE_WITH_CAMERA)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            result.append(CHOOSE_PICTURE_FROM_GALLERY)
        }
        
        result.append(REMOVE_PICTURE)
        
        return result
    }
    
}
