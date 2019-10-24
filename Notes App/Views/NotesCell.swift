//
//  NotesCell.swift
//  Notes App
//
//  Created by jason smellz on 10/17/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {
    
    var note: Note! {
        didSet {
            cellView.titleView.text = note.body
            cellView.dateView.text = note.dateString
            cellView.bodyView.text = note.body.truncateBody
        }
    }
    
    lazy var cellView: CellView = {
        let cellView = CellView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        return cellView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView() {
        
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(cellView)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
       NSLayoutConstraint.activate([
        cellView.heightAnchor.constraint(equalToConstant: 110),
        cellView.centerYAnchor.constraint(equalTo: centerYAnchor),
        cellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
        cellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17)
        ])
    }

}

class CellView: UIView {
    
    lazy var paddedView: UIView = {
        let paddedView = UIView()
        paddedView.translatesAutoresizingMaskIntoConstraints = false
        return paddedView
    }()
    
    lazy var titleView: UILabel = {
        let titleView = UILabel()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.textColor = .white
        titleView.font = UIFont.cellHeading
        return titleView
    }()
    
    lazy var bodyView: UILabel = {
        let bodyView = UILabel()
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.textColor = .white
        bodyView.font = UIFont.cellBody
        bodyView.numberOfLines = 2
        return bodyView
    }()
    
    lazy var dateView: UILabel = {
        let dateView = UILabel()
        dateView.translatesAutoresizingMaskIntoConstraints = false
        dateView.textColor = .white
        dateView.font = UIFont.cellDate
        dateView.textAlignment = .right
        return dateView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView() {
        backgroundColor = UIColor.notesCellBackground
        addSubview(paddedView)
        addSubview(titleView)
        addSubview(bodyView)
        addSubview(dateView)
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.borderColor = UIColor.notesCellBorder.cgColor
        layer.borderWidth = 0.25
    }
    
    fileprivate func setupLayout() {
        NSLayoutConstraint.activate([
            paddedView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            paddedView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 17),
            paddedView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            paddedView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -17),
            bodyView.leadingAnchor.constraint(equalTo: paddedView.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: paddedView.trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: paddedView.bottomAnchor),
            dateView.trailingAnchor.constraint(equalTo: paddedView.trailingAnchor),
            dateView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            dateView.widthAnchor.constraint(equalToConstant: 80),
            titleView.leadingAnchor.constraint(equalTo: paddedView.leadingAnchor),
            titleView.topAnchor.constraint(equalTo: paddedView.topAnchor),
            titleView.trailingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: -20)
            ])
    }
    
}


