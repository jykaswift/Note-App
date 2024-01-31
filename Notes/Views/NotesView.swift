//
//  NotesView.swift
//  Notes
//
//  Created by Евгений Борисов on 27.01.2024.
//

import UIKit

class NotesView: UIView {
    
    weak var notesController: NotesController?
    private var tableDataSource: UITableViewDiffableDataSource<TableSection, Note>?
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Заметки"
        titleLabel.font = UIFont.systemFont(ofSize: 32)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemGray6
        addSubview(titleLabel)
        addSubview(tableView)
        setupLayout()
    }
    
    private func setupLayout() {
        let margin: CGFloat = 10
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: margin),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
        ])
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}

// MARK: Setup TableView style
extension NotesView {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: TableView delegate
extension NotesView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notesController?.openEditPage(withNoteIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash.slash")) { (action) in
                self.notesController?.deleteNote(withNoteIndex: indexPath.row)
            }
            
            return UIMenu(children: [deleteAction])
        }
    }
}

// MARK: TableView DataSource
extension NotesView {
    enum TableSection {
        case note
    }
    
    /// Datasource initialization
    private func setupDataSource() {
        tableDataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, note in
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as! NoteTableViewCell
            cell.setData(withNote: note)
            return cell
        })
    }
    
    
    /// Table appearance update
    /// - Parameter notes: Updated notes list
    func updateTable(with notes: [Note]) {
        var snapshop = NSDiffableDataSourceSnapshot<TableSection, Note>()
        snapshop.appendSections([.note])
        snapshop.appendItems(notes, toSection: .note)
        tableDataSource?.apply(snapshop, animatingDifferences: false)
    }
}


