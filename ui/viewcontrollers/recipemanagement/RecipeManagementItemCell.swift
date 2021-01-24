//
//  RecipeManagementItemCellCollectionViewCell.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 01.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RecipeManagementItemCell: UICollectionViewCell {
    //fields with property observers
    var isMarked: Bool = false{
        willSet(marked){
            if marked{
                if let colorAccent = UIColor.colorAccent{
                    imgSelectedState.tintColor = colorAccent
                }
            }
            else{
                imgSelectedState.tintColor = UIColor.systemGray3
            }
        }
    }
    
    var markingPossible : Bool = false{
        willSet(newVal){
            isMarked = false
            imgSelectedState.isHidden = !newVal
        }
    }
    
    //outlets
    @IBOutlet weak var imgRecipe: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgSelectedState: UIImageView!
    
    //lifecycle functions
    override func awakeFromNib() {
        super.awakeFromNib()
        //configure cell itself
        layer.cornerRadius = CGFloat(8)
    }
    
    //functions
    func toggleMarkedState(){
        isMarked = !isMarked
    }
    
}
