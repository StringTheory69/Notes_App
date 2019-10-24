//
//  HeadingLabel.swift
//  Notes App
//
//  Created by jason smellz on 10/24/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit


class HeadingLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = "Notes"
        font = UIFont.heading
        textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
