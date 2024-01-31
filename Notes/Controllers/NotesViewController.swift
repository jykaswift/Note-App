//
//  ViewController.swift
//  Notes
//
//  Created by Евгений Борисов on 27.01.2024.
//

import UIKit


/// Protocol for communication between view and controller
protocol NotesController: AnyObject {
    func openEditPage(withNoteIndex index: Int)
    func deleteNote(withNoteIndex index: Int)
}

class NotesViewController: UIViewController {
    
    private lazy var notesView = NotesView(frame: .zero)
    private lazy var dataManager = DataManager()
    
    override func loadView() {
        notesView.notesController = self
        view = notesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        dataManager.saveDefaultNote()
        dataManager.obtainSavedData()
        notesView.updateTable(with: dataManager.getDataSource())
    }
    
   
}

// MARK: Navigation bar
extension NotesViewController {
    private func setupNavigationBar() {
        let addAction = UIAction { _ in
            let editVC = EditNoteViewController()
            editVC.delegate = self
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addAction)
        navigationController?.navigationBar.tintColor = .black
    }
}


// MARK: Edit Note Delegate
extension NotesViewController: EditNoteDelegate {
    func createNote(withTitle title: String?, andDate date: Date, andContent content: NSAttributedString?) -> Note {
        dataManager.createNote(withTitle: title, andDate: date, andContent: content)
    }
    
    func updateDataSource(with note: Note) {
        dataManager.updateDataSource(with: note)
        notesView.updateTable(with: dataManager.getDataSource())
    }
}


// MARK: Notes Controller Protocol
extension NotesViewController: NotesController {
    func deleteNote(withNoteIndex index: Int) {
        dataManager.deleteNote(withNoteIndex: index)
        notesView.updateTable(with: dataManager.getDataSource())
    }
    
    func openEditPage(withNoteIndex index: Int) {
        let note = dataManager.getDataSource()[index]
        let editVC = EditNoteViewController()
        editVC.delegate = self
        editVC.note = note
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
}
