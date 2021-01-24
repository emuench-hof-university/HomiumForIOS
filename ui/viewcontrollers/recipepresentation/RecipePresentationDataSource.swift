//
//  RecipePresentationDataSource.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 04.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RecipePresentationDataSource: NSObject, UITableViewDataSource {
    
    //fields
    var dataHandler : RecipePresentationDataHandler? = nil{
        didSet{
            loadDataFromModel()
        }
    }
    
    
    
    var title = String.EMPTY
    var image = UIImage.noRecipeImage ?? UIImage(){
        didSet{
            onPictureDidChange(image)
        }
    }
    
    var onPictureDidChange : (UIImage) -> Void = {_ in}
    private var descriptions = [String]()
    private var ingredients = [(title: String, quantityDetails: String)]()
    
    private var currentSegment : RecipePresentationViewSegment = RecipePresentationViewSegment.INGREDIENTS
    
    
    
    //protocol functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Implement number of rows in section
        if currentSegment == RecipePresentationViewSegment.INGREDIENTS{
            return ingredients.count
        }
        else if currentSegment == RecipePresentationViewSegment.DESCRIPTIONS{
            return descriptions.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentSegment == RecipePresentationViewSegment.INGREDIENTS{
            //get cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipePresentationIngredientCell.reuseIdentifier, for: indexPath) as? RecipePresentationIngredientCell else{
                return UITableViewCell()
            }
            
            //configure cell
            cell.lblTitle.text = ingredients[indexPath.row].title
            cell.lblQuantityDetails.text = ingredients[indexPath.row].quantityDetails
            return cell
            
        }
        else if currentSegment == RecipePresentationViewSegment.DESCRIPTIONS{
            //get cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipePresentationDescriptionCell.reuseIdentifier, for: indexPath) as? RecipePresentationDescriptionCell else{
                return UITableViewCell()
            }
            
            //configure cell
            cell.lblIndex.text = (indexPath.row + 1).description
            cell.lblContent.text = descriptions[indexPath.row]
            
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //functions
    func loadDataFromModel(){
        if let data = dataHandler?.getData(){
            title = data.title
            image = data.image
            descriptions = data.descriptions
            ingredients = data.ingredients
        }
    }
    
    func changeViewSection(of tableView: UITableView,to segment: RecipePresentationViewSegment){
        self.currentSegment = segment
        tableView.reloadData()
    }
    
    func getDescriptionAt(index: Int) -> String?{
        if(index < 0 || index >= descriptions.count){
            return nil
        }
        else{
            return descriptions[index]
        }
    }
    

    
    enum RecipePresentationViewSegment{
        case INGREDIENTS
        case DESCRIPTIONS
    }
}


