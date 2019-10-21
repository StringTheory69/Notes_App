//
//  Views.swift
//  Notes App
//
//  Created by jason smellz on 10/17/19.
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

class CircleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.notesBlack
        setImage(#imageLiteral(resourceName: "noun_Plus_2138966"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.width/2
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 65, height: 65)
    }
}
