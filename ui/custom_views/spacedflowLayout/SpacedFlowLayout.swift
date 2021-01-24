//
//  SpacedFlowLayout.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 01.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class SpacedFlowLayout: UICollectionViewFlowLayout {
    
    init(screenWidth: CGFloat){
        super.init()
       //configure layout
        self.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 1)
        self.itemSize = CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/4)
        minimumInteritemSpacing = 8
        minimumLineSpacing = 8
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
