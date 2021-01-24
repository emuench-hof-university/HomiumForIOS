//
//  RecipeEditIngredientCell.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 23.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RecipeEditIngredientCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblQuantityDetails: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
