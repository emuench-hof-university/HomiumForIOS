//
//  RecipeEditHeaderCell.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 23.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RecipeEditHeaderCell: UITableViewCell, UITextFieldDelegate {

    //fields
    var titleTextChangeListener : (UITextField) -> Void = {_ in}
    var pictureButtonTouchedListener : (UIButton) -> Void = {_ in}
    
    //outlets
    @IBOutlet weak var txtTitle: UITextField!
    
    //actions
    @IBAction func btnPictureTouched(_ sender: UIButton) {
        pictureButtonTouchedListener(sender)
    }
    
    
    
    //lifecycle functions
    override func awakeFromNib() {
        super.awakeFromNib()
        txtTitle.delegate = self
        txtTitle.addTarget(self, action: #selector(titleChanged), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    //textfield handling
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    //react on textfield change
    @objc private func titleChanged(){
        titleTextChangeListener(txtTitle)
    }
    
}
