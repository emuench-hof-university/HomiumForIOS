//
//  RecipeDescriptionPresentationViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 06.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RecipeDescriptionPresentationViewController : BaseViewController{
    //fields
    var dataHandler : RecipeDescriptionPresentationDataHandler? = nil
    
    //outlets
    @IBOutlet private weak var lblDescription: UILabel!
    
    //lifecycle functions
    override func viewDidLoad() {
        lblDescription.text = dataHandler?.getData() ?? String.EMPTY
    }
    
    
}
