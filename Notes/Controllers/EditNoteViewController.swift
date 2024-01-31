//
//  EditNoteViewController.swift
//  Notes
//
//  Created by Евгений Борисов on 27.01.2024.
//

import UIKit
import PhotosUI


/// Protocol for communication of the first vc with the second vc
protocol EditNoteDelegate: AnyObject {
    func updateDataSource(with note: Note)
    func createNote(withTitle title: String?, andDate date: Date, andContent content: NSAttributedString?) -> Note
}

/// Protocol for communication between view and controller
protocol EditNoteProtocol: AnyObject {
    func generateAttributes(withTextAttributes textAttributes: TextAttributes) -> [NSAttributedString.Key: Any]
    func getTextAttributes(typingAttributes: [NSAttributedString.Key: Any]) -> TextAttributes
    func getCurrentNote() -> Note?
    func pickImage()
}


class EditNoteViewController: UIViewController {
    private let attributedStringManager = AttributedStringManager()
    private lazy var editView = EditNoteView(frame: .zero)
    weak var delegate: EditNoteDelegate?
    var note: Note?
    
    override func loadView() {
        editView.editNoteController = self
        view = editView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editView.setupData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveNote()
    }
    
    func getCurrentNote() -> Note? {
        return note
    }
    
}


// MARK: Navigation bar
extension EditNoteViewController {
    private func setupNavigationBar() {
        navigationItem.title = "Editing"
    }
}


// MARK: Text attributes control
extension EditNoteViewController: EditNoteProtocol {

    func generateAttributes(withTextAttributes textAttributes: TextAttributes) -> [NSAttributedString.Key: Any] {
        return attributedStringManager.generateAttributesWith(textAttributes: textAttributes)
    }
    
    func getTextAttributes(typingAttributes: [NSAttributedString.Key: Any]) -> TextAttributes {
        return attributedStringManager.getTextAttributes(typingAttributes: typingAttributes)
    }
}

// MARK: Data Source methods
extension EditNoteViewController {
    private func saveNote() {
        let noteData = editView.getNoteData()
        
        if note == nil  {
            if noteData.content == nil || noteData.content!.string.isEmpty { return }
            note = delegate!.createNote(
                    withTitle: noteData.title,
                    andDate: Date.now,
                    andContent: noteData.content
            )
        } else {
            note?.content = noteData.content
            note?.title = noteData.title
        }
        
        delegate?.updateDataSource(with: note!)
        
    }
}

// MARK: Pick image

extension EditNoteViewController: PHPickerViewControllerDelegate {
    
    func pickImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for i in results.indices {
            let itemprovider = results[i].itemProvider
            if itemprovider.canLoadObject(ofClass: UIImage.self){
                itemprovider.loadObject(ofClass: UIImage.self) { image , error  in
                    if let error{
                        print(error)
                    }
                    if let selectedImage = image as? UIImage{
                        DispatchQueue.main.async {
                            self.editView.uploadImage(image: selectedImage)
                        }
                    }
                }
            }
        }
       
    }
    
}
