//
//  UICoreDesignLabel.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 04.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class UICoreDesignLabel: UILabel {

    @IBInspectable var paddingTop : CGFloat = 0
    @IBInspectable var paddingBottom : CGFloat = 0
    @IBInspectable var paddingLeft : CGFloat = 0
    @IBInspectable var paddingRight : CGFloat = 0
    @IBInspectable var cornerRadius : CGFloat = 0
    
    public override var intrinsicContentSize: CGSize{
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + paddingLeft + paddingRight, height: size.height + paddingTop + paddingBottom)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //setting corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let textInsets = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        let textRect = super.textRect(forBounds: bounds.inset(by: textInsets), limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
        
        return textRect.inset(by: invertedInsets)
    }
    
    

}
