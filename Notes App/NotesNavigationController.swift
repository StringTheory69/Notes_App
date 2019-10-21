//
//  NotesNavigationController.swift
//  Notes App
//
//  Created by jason smellz on 10/17/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit

class NotesNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = UIColor.notesBackground
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        }

        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    

}
