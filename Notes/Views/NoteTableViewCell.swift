//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Евгений Борисов on 27.01.2024.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.textAlignment = .left
        return contentLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    private lazy var cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = .white
        cellView.layer.cornerRadius = 5
        return cellView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets the data for the cell
    /// - Parameter note: original data note
    func setData(withNote note: Note) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = dateFormatter.string(from: note.date)
        
        if let title = note.title, !title.isEmpty {
            titleLabel.text = title
        } else {
            titleLabel.text = "New Note"
        }
        
        if let content = note.content?.string, !content.isEmpty {
            contentLabel.text = content
        } else {
            contentLabel.text = "No text"
        }
        
    }
    
    private func setupCell() {
        contentView.addSubview(cellView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(contentLabel)
        cellView.addSubview(dateLabel)
        contentView.backgroundColor = .systemGray6
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        ])

        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10)
        ])
        
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            dateLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),
            contentLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
        ])
    }

}

extension NoteTableViewCell {
    static var reuseIdentifier: String {
        return String(self.description())
    }
}
