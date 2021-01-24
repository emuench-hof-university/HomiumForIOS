//
//  RecipeManagementHeader.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 03.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RecipeManagementHeader: UICollectionReusableView {
    //static variables
    static let reuseIdentifier = "recipeManagementHeader"
    
    //outlets
    @IBOutlet private weak var lblHeadline: UILabel!
    
    //set Title
    func setText(text : String){
        lblHeadline.text = text
    }
    
    func changeTextToCurrentMarkCount(markCount : Int){
        setText(text: ESSENTIAL_PHRASE_HEADLINE_RECIPE_EDITINGMODE.replacingOccurrences(of: "#", with: markCount.description))
    }
}
