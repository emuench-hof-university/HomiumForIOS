//
//  IOSUIExtensions.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 16.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

extension UIViewController : MessageDelegate{
    func showMessage(title : String = ESSENTIAL_STRING_MESSAGE, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ESSENTIAL_STRING_OK, style: .default, handler: nil))
        
        self.present(alert,animated: true)
    }
    
    func showAlertDialog(title: String = ESSENTIAL_STRING_MESSAGE, msg: String, onYes : @escaping () -> Void,  onNo : @escaping () -> Void = {}, isDestructiveOperation : Bool = false, noIsDestructiveToo: Bool = false){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        //yes
        let yesStyle : UIAlertAction.Style  = isDestructiveOperation ? .destructive : .default
        alert.addAction(UIAlertAction(title: ESSENTIAL_STRING_YES, style: yesStyle, handler: {(_ : UIAlertAction) -> Void in
            onYes()
        }))
        
        //no
        let noStyle : UIAlertAction.Style  = noIsDestructiveToo ? .destructive : .default
        alert.addAction(UIAlertAction(title: ESSENTIAL_STRING_NO, style: noStyle, handler: {(_ : UIAlertAction) -> Void in
            onNo()
        }))
        
        //present
        self.present(alert,animated: true)
    }
}

extension UIViewController : ChooserDialogDelegate{
    func showValueChooserDialog<T : CustomStringConvertible>(title: String = String.EMPTY,msg: String = String.EMPTY,values: [T], onChoose: @escaping (T) -> Void, onCancel : @escaping () -> Void = {}, sender: UIView){
        //creating alertcontroller
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        
        //adding choose actions
        for value in values{
            alert.addAction(UIAlertAction(title: value.description, style: .default, handler: {(_ : UIAlertAction) -> Void in
                onChoose(value)
            }))
        }
        
        //cancel action
        alert.addAction(UIAlertAction(title: ESSENTIAL_STRING_CANCEL, style: .cancel, handler: {(_ : UIAlertAction) -> Void in
            onCancel()
        }))
        
        //popover for ipad
        if let popover = alert.popoverPresentationController{
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.permittedArrowDirections = .any
        }
        
        //present alertdialog
        self.present(alert,animated: true)
    }
}

extension UIViewController : UIPresenterDelegate{}

extension UIImage{
    static let noRecipeImage : UIImage? = UIImage(named: "NoRecipePicture")

}
