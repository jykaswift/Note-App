//
//  DataManager.swift
//  Notes
//
//  Created by Евгений Борисов on 28.01.2024.
//

import Foundation
import UIKit



class DataManager  {
    private let coreDataManager = CoreDataManager()
    private var dataSource = [Note]()
    private var userDefaults = UserDefaults(suiteName: "first launch")
    
    /// Creating a note in a backgrounder context.
    /// - Parameters:
    ///   - title: String value, note title
    ///   - date: Date of note creation
    ///   - content: AttributedString value, note content
    /// - Returns: Note object
    func createNote(withTitle title: String?, andDate date: Date, andContent content: NSAttributedString?) -> Note {
        let note = Note(context: coreDataManager.backGroundContrext)
        
        note.title = title
        note.date = Date()
        note.content = content

        return note
    }
    
    
    /// Adding a new note or modifying an existing note in the dataset and database
    /// - Parameter note: Note object, update data
    func updateDataSource(with note: Note) {
        Task {
           await coreDataManager.saveBackgroundContex()
        }
        
        guard let index = dataSource.firstIndex(where: { currentNote in
            return currentNote.id == note.id
        }) else {
            dataSource.insert(note, at: 0)
            return
        }
        dataSource[index] = note
    }
    
    
    /// Deleting a note from the dataset and database
    /// - Parameter index: Int value, note index in the dataset
    func deleteNote(withNoteIndex index: Int) {
        let note = dataSource.remove(at: index)
        
        if note.managedObjectContext == coreDataManager.viewContext {
            coreDataManager.viewContext.delete(note)
        } else {
            coreDataManager.backGroundContrext.delete(note)
        }
        
        Task {
           await coreDataManager.saveBackgroundContex()
        }
    }
    
    func obtainSavedData() {
        dataSource = coreDataManager.obtainSavedData()
    }
    
    func getDataSource() -> [Note] {
        return dataSource
    }
    
    
    /// Creating and saving a basic note when the application is first launched
    func saveDefaultNote() {
        if let isFirstLaunch = userDefaults?.bool(forKey: "defaultData"), isFirstLaunch {
           return
        }
        
        let note = Note(context: coreDataManager.viewContext)
        
        note.title = "Write something here!"
        note.date = Date()
        note.content = createDeaultNoteContent()
        
        coreDataManager.saveContext()
        userDefaults?.setValue(true, forKey: "defaultData")
    }
    
    
    /// Creating basic note content
    /// - Returns: NSAttributedString value with example attributes
    private func createDeaultNoteContent() -> NSAttributedString {
        let defaultFont = UIFont.systemFont(ofSize: 16)
        
        let welcomeText = NSMutableAttributedString(
            string: "Hi, this is your first note.\n",
            attributes: [.font: UIFont.systemFont(ofSize: 24)]
        )
        
        let descriptionText = NSAttributedString(
            string: "you can make text ",
            attributes: [
                .font: defaultFont
            ])
        
        let bold = NSAttributedString(
            string: "bold, ",
            attributes: [
                .font: defaultFont.withTraits([.traitBold])
            ])
        
        let italicized = NSAttributedString(
            string: " italicized, ",
            attributes: [
                .font: defaultFont.withTraits([.traitItalic])
            ])
        
        let underlined = NSAttributedString(
            string: "underlined,",
            attributes: [
                .font: defaultFont,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        
        let commonStyles = NSAttributedString(
            string: "or all of the above.",
            attributes: [
                .font: defaultFont.withTraits([.traitBold, .traitItalic]),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        
        welcomeText.append(descriptionText)
        welcomeText.append(bold)
        welcomeText.append(underlined)
        welcomeText.append(italicized)
        welcomeText.append(commonStyles)
        
        return welcomeText
    }
}
