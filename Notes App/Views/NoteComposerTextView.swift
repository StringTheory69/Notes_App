//
//  NoteComposerTextView.swift
//  Notes App
//
//  Created by jason smellz on 10/24/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit

class NoteComposerTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        isScrollEnabled = true
        backgroundColor = .clear
        textColor = .white
        font = UIFont.cellBody
    }
}
