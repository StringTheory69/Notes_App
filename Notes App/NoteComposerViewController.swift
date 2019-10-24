//
//  NoteComposerViewController.swift
//  Notes App
//
//  Created by jason smellz on 10/17/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit

class NoteComposerViewController: UIViewController, UITextViewDelegate {
    
    var note: Note!
    
    // ? weak
    weak var delegate: NotesMainViewController!
    
    lazy var bottomConstraint: NSLayoutConstraint = {
        let bottomConstraint = noteComposerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        return bottomConstraint
    }()
    
    lazy var circleButton: CircleButton = {
        let circleButton = CircleButton()
        circleButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        circleButton.backgroundColor = UIColor.notesRed
        circleButton.setImage(#imageLiteral(resourceName: "x_icon"), for: .normal)
        circleButton.translatesAutoresizingMaskIntoConstraints = false
        return circleButton
    }()

    lazy var noteComposerView : NoteComposerView = {
        let noteComposerView = NoteComposerView()
        noteComposerView.translatesAutoresizingMaskIntoConstraints = false
        return noteComposerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.notesBackground
        view.addSubview(noteComposerView)
        setupView()
    }
    
    func setupView() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        noteComposerView.text = self.note.body
        
        navigationItem.title = self.note.dateString
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKeyboard))
        rightButtonHide(true)
        
        view.addSubview(circleButton)
        
        setupLayout()
    
    }
    
    @objc func deleteAction() {
        
        delegate.deleteAction(note)
        delegate.blankNoteActive = false
        navigationController?.popViewController(animated: true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard noteComposerView.text != "" else {return deleteAction()}

        // if some text has been added
        delegate.blankNoteActive = false
        note.body = noteComposerView.text
        delegate.saveContext()
        delegate.loadSavedData()

    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            circleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            circleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            noteComposerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            noteComposerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteComposerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            bottomConstraint
            ])
    
    }
    
    deinit {
        print("DEINIT")
    }
    
    func updateConstraint(_ newHeight: CGFloat) {
        print(newHeight)
        bottomConstraint.constant = newHeight
        
        UIView.animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    func rightButtonHide(_ hide: Bool) {
        
        if let button = self.navigationItem.rightBarButtonItem {
            
            if hide {
                button.isEnabled = false
                button.tintColor = UIColor.clear
            } else {
                button.isEnabled = true
                button.tintColor = UIColor.white
            }

        }
    }
    
    @objc func hideKeyboard() {
        rightButtonHide(true)
        noteComposerView.resignFirstResponder()
    }
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        
        rightButtonHide(false)
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            updateConstraint(-keyboardHeight)
            
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        updateConstraint(0)
    }

}


// TODO = put in scroll view 

class NoteComposerView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        isScrollEnabled = true
        backgroundColor = .clear
        textColor = .white
        font = UIFont.cellBody
    }
    
}

