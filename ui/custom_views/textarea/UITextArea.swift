//
//  UITextArea.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 23.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class UITextArea: UITextView, UITextViewDelegate {

    //Interface variables
    @IBInspectable var placeholderText : String = ""
    @IBInspectable var placeholderColor : UIColor = UIColor.systemGray4
    @IBInspectable var borderColor : UIColor = UIColor.systemGray4
    @IBInspectable var borderWidth : CGFloat = 2
    @IBInspectable var cornerRadius : CGFloat = 8
    
    //changelistener
    var onTextChangedListener : (UITextArea) -> Void = {(txt: UITextArea) in}
    
    //lifecycle functions
    override func awakeFromNib() {
        super.awakeFromNib()
        //setting corner radius
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.borderWidth = self.borderWidth/UIScreen.main.nativeScale
        layer.borderColor = borderColor.cgColor
        
        //react on changed via delegate functions
        delegate = self
        
        //placeholder init
        if (text.isEmpty){
            text = placeholderText
            textColor = placeholderColor
        }
        
    }
    
    override func layoutSubviews() {
        if (text.isEmpty){
            text = placeholderText
            textColor = placeholderColor
        }
    }
    
    //delegate functions
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor{
            textView.text = String.EMPTY
            setTextColorDependingOnUIMode()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = placeholderText
            textView.textColor = placeholderColor
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let casted = textView as? UITextArea else{
            return
        }
        
        onTextChangedListener(casted)
    }
    
    //darkmode and ui changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        layer.borderColor = borderColor.cgColor
        if textColor != placeholderColor{
            setTextColorDependingOnUIMode()
        }
    }
    
    private func isDarkMode() -> Bool{
        return self.traitCollection.userInterfaceStyle == .dark
    }
    
    private func setTextColorDependingOnUIMode(){
        if isDarkMode(){
            textColor = UIColor.white
        }
        else{
            textColor = UIColor.black
        }
    }

}
