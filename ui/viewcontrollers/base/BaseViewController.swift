//
//  BaseViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 09.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController, UITextFieldDelegate{
    
    
    //indicator for hiding navigationbar
    var navigationBarIsHidden : Bool = false
    
    //default implementations of some lifecycle functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(navigationBarIsHidden){
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(!navigationBarIsHidden){
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        //register keyboard change events
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDidChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDidChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //clean up in deinit
    deinit {
        //unregister keyboard change events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //keyboard stuff
    var onKeyboardDidExpand : (UIEdgeInsets) -> Void = {_ in}
    var onKeyboardDidHide : (UIEdgeInsets) -> Void = {_ in}
    
    func setupNumberKeyboard(forTextField txt: UITextField){
        //set keyboard type
        txt.keyboardType = UIKeyboardType.decimalPad
        
        //setup toolbar for done button
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: ESSENTIAL_STRING_OK, style: .done, target: self, action: #selector(onNumberKeyboardDonePressed))
        doneBtn.tintColor = UIColor.colorAccent
        toolbar.setItems([flexSpace,doneBtn], animated: false)
        toolbar.sizeToFit()
        
        //connect toolbar with textfield
        txt.inputAccessoryView = toolbar
    }
    
    @objc private func onNumberKeyboardDonePressed(){
        self.view.endEditing(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func onKeyboardDidChange(notification: Notification){
        guard let userinfo = notification.userInfo else{
            return
        }
        
        guard let keyboardScreenEndFrame = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            print("keyboard will hide")
            onKeyboardDidHide(UIEdgeInsets.zero)
        }
        else if notification.name == UIResponder.keyboardWillChangeFrameNotification{
            print("keyboard will expand")
            onKeyboardDidExpand(UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0))
        }
    }

    
}
