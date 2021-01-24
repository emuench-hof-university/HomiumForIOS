//
//  RecipeEditDescriptionCell.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 23.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RecipeEditDescriptionCell: UITableViewCell{

    //outlets
    @IBOutlet weak var txtAreaDescriptionText: UITextArea!
    @IBOutlet weak var lblIndex: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupKeyboard(forTextField: txtAreaDescriptionText)
    }

    //change listener
    func setOnDescriptionChangeListener(_ fun :@escaping (UITextArea) -> Void){
        txtAreaDescriptionText.onTextChangedListener = fun
    }
    
    //functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
    //keyboard stuff
    func setupKeyboard(forTextField txt: UITextView){
        
        //setup toolbar for done button
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: self.frame.width, height: 20)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: ESSENTIAL_STRING_OK, style: .done, target: self, action: #selector(onDoneTouched))
        doneBtn.tintColor = UIColor.colorAccent
        toolbar.setItems([flexSpace,doneBtn], animated: false)
        toolbar.sizeToFit()
        
        //connect toolbar with textfield
        txt.inputAccessoryView = toolbar
    }
    
    @objc private func onDoneTouched(){
        self.endEditing(false)
    }
    
    func closeKeyboard(){
        txtAreaDescriptionText.resignFirstResponder()
    }
    

}
