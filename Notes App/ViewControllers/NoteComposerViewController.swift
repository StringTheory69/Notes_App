//
//  NoteComposerViewController.swift
//  Notes App
//
//  Created by jason smellz on 10/17/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit

class NoteComposerViewController: UIViewController, UITextViewDelegate {
    
    weak var delegate: NotesMainViewController!
    var note: Note!

    lazy var bottomConstraint: NSLayoutConstraint = {
        let bottomConstraint = noteComposerTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        return bottomConstraint
    }()
    
    lazy var circleButton: CircleButton = {
        let circleButton = CircleButton()
        circleButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        circleButton.deleteMode = true
        return circleButton
    }()

    lazy var noteComposerTextView = NoteComposerTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handleDisappear()
    }
}

// setup
    
extension NoteComposerViewController {
    
    fileprivate func setupView() {
        
        view.backgroundColor = UIColor.notesBackground
        view.addSubview(noteComposerTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationItem.title = self.note.dateString
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKeyboard))
        hideDoneButton(true)
        
        noteComposerTextView.text = self.note.body
        view.addSubview(circleButton)
        
        setupLayout()
    
    }
    
    fileprivate func setupLayout() {
        
        NSLayoutConstraint.activate([
            circleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            circleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            noteComposerTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            noteComposerTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteComposerTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            bottomConstraint
            ])
    }
}

// involving delegate

extension NoteComposerViewController {
    
    fileprivate func handleDisappear() {
        
        guard noteComposerTextView.text != "" else {return deleteAction()}
        
        // in case note was added as a blank note
        delegate.blankNoteActive = false
        
        // if text has been modified
        guard noteComposerTextView.text != note.body else {return}
        
        note.body = noteComposerTextView.text
        delegate.saveContext()
        delegate.loadSavedData()
    }
    
    @objc fileprivate func deleteAction() {
        
        delegate.deleteAction(note)
        delegate.blankNoteActive = false
        navigationController?.popViewController(animated: true)
    }
    
}

// keyboard related UI actions and animations

extension NoteComposerViewController {
    
    // animate bottom anchor constant when keyboard is hidden / not hidden
    fileprivate func animateBottomConstraint(_ newBottomConstant: CGFloat) {

        bottomConstraint.constant = newBottomConstant
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func hideKeyboard() {
        noteComposerTextView.resignFirstResponder()
    }
    
    fileprivate func hideDoneButton(_ hide: Bool) {
        
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
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        
        hideDoneButton(false)
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            animateBottomConstraint(-keyboardHeight)
            
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        hideDoneButton(true)
        animateBottomConstraint(0)
    }
    
    @objc fileprivate func applicationWillTerminate() {
        handleDisappear()
    }

}

