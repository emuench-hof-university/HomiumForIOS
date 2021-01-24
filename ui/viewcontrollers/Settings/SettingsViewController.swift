//
//  SettingsViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 03.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    //fields
    private let delegate = SettingsTableViewDelegate()

    //outlets
    @IBOutlet private weak var switchShoppingDeleteQuestion: UISwitch!
    
    @IBOutlet private weak var switchInventoryDeleteQuestion: UISwitch!
    @IBOutlet private weak var lblInventorySortAlgorithm: UILabel!
    @IBOutlet weak var lblInventoryImportOptions: UILabel!
    @IBOutlet weak var switchAutoLocationIntegration: UISwitch!
    @IBOutlet private weak var switchRecipeDeleteQuestion: UISwitch!
    
    //actions
    @IBAction private func switchShoppingDeleteQuestionValueChanged(_ sender: UISwitch) {
        HomiumSettings.instance.putUserSetting(value: sender.isOn, key: USER_SETTING_SHOPPING_DELETE_QUESTION_ALLOWED)
    }
    
    @IBAction private func switchInventoryDeleteQuestionValueChanged(_ sender: UISwitch) {
        HomiumSettings.instance.putUserSetting(value: sender.isOn, key: USER_SETTING_INVENTORY_DELETE_QUESTION_ALLOWED)
    }
    
    @IBAction func switchAutoLocationIntegrationValueChanged(_ sender: UISwitch) {
        HomiumSettings.instance.putUserSetting(value: sender.isOn, key: USER_SETTING_INVENTORY_AUTO_LOCATION_INTEGRATION)
    }
    
    @IBAction func switchRecipeDeleteQuestionValueChanged(_ sender: UISwitch) {
        HomiumSettings.instance.putUserSetting(value: sender.isOn, key: USER_SETTING_RECIPE_DELETE_QUESTION_ALLOWED)
    }
    
    //lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure section header
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 40
        tableView.register(ResizeableTableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: ResizeableTableViewSectionHeader.reuseIdentifier)
        
        //delegate
        tableView.delegate = delegate
        delegate.vc = self
        
        //assign Settings Values to GUI
        //shopping delete question
        switchShoppingDeleteQuestion.isOn = HomiumSettings.instance.getUserSetting(key: USER_SETTING_SHOPPING_DELETE_QUESTION_ALLOWED) ?? true
        
        //inventory delete question
        switchInventoryDeleteQuestion.isOn = HomiumSettings.instance.getUserSetting(key: USER_SETTING_INVENTORY_DELETE_QUESTION_ALLOWED) ?? true
        
        //inventory sort
        let inventorySortId : String = HomiumSettings.instance.getUserSetting(key: USER_SETTING_INVENTORY_SORT_ALGORITHM_ID) ?? InventorySortAlgorithms.alphabeticSort.id
        lblInventorySortAlgorithm.text = InventorySortAlgorithms.getById(id: inventorySortId)?.shortDescription ?? InventorySortAlgorithms.alphabeticSort.shortDescription
        
        //inventory import options
        let inventoryImportOptionId : String = HomiumSettings.instance.getUserSetting(key: USER_SETTING_INVENTORY_IMPORT_OPTIONS) ?? InventoryImportOptions.defaultOption().id
        lblInventoryImportOptions.text = InventoryImportOptions.getByIdOrDefault(id: inventoryImportOptionId).shortDescription
        
        //inventory auto location integration
        switchAutoLocationIntegration.isOn = HomiumSettings.instance.getUserSetting(key: USER_SETTING_INVENTORY_AUTO_LOCATION_INTEGRATION) ?? true
        
        //recipe delete question
        switchRecipeDeleteQuestion.isOn = HomiumSettings.instance.getUserSetting(key: USER_SETTING_RECIPE_DELETE_QUESTION_ALLOWED) ?? true
        
        
    }
    
    func onInventorySortAlgorithmChanged(newAlgorithmName : String){
        lblInventorySortAlgorithm.text = newAlgorithmName
    }
    
    func onInventoryImportOptionsChanged(newOption: String){
        lblInventoryImportOptions.text = newOption
    }
    
    

}
