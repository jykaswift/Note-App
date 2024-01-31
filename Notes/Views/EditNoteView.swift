//
//  EditNoteView.swift
//  Notes
//
//  Created by Евгений Борисов on 27.01.2024.
//

import UIKit


class EditNoteView: UIView  {
    var isCustomView = false
    weak var editNoteController: EditNoteProtocol?
    
    private lazy var titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.borderStyle = .none
        titleTextField.placeholder = "Note title..."
        titleTextField.textAlignment = .center
        titleTextField.returnKeyType = .next
        titleTextField.delegate = self
        return titleTextField
    }()
    
    private lazy var formatMenu: FormatMenu = {
        let formatMenu = FormatMenu()
        formatMenu.parentView = self
        return formatMenu
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
        let formatAction = UIAction { [unowned self] _ in self.toggleInputView() }
        let imageAction = UIAction { [unowned self] _ in editNoteController?.pickImage() }
        let doneAction = UIAction { [unowned self] _ in self.contentTextView.resignFirstResponder() }
        let formatButton = UIBarButtonItem(image: UIImage(systemName: "textformat"), primaryAction: formatAction)
        let imageButton = UIBarButtonItem(image: UIImage(systemName: "photo.artframe"), primaryAction: imageAction)
        let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)
    
        let doneButton = UIBarButtonItem(systemItem: .done, primaryAction: doneAction)
        toolBar.setItems([formatButton, imageButton, flexibleSpace, doneButton], animated: false)
        return toolBar
    }()
    
    
    private lazy var contentTextView: UITextView = {
        let contentTextView = UITextView()
        contentTextView.inputAccessoryView = toolBar
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.font = UIFont.systemFont(ofSize: 16)
        contentTextView.delegate = self
        return contentTextView
    }()
    
    private lazy var borderView: UIView = {
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = .systemGray5
        return borderView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupKeyboardHiding()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData() {
        guard let note = editNoteController?.getCurrentNote() else { return }
        titleTextField.text = note.title
        contentTextView.attributedText = note.content
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(titleTextField)
        addSubview(contentTextView)
        addSubview(borderView)
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            titleTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
            titleTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5),
            titleTextField.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        NSLayoutConstraint.activate([
            borderView.heightAnchor.constraint(equalToConstant: 3),
            borderView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5),
            borderView.bottomAnchor.constraint(equalTo: contentTextView.topAnchor),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
        ])
        
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func getNoteData() -> (title: String?, content: NSAttributedString?) {
        return (titleTextField.text, contentTextView.attributedText)
    }
    
}


// MARK: Update text attribites

extension EditNoteView {
    func updateAttributesWith(textAttributes: TextAttributes) {
        let newAttributes = editNoteController!.generateAttributes(withTextAttributes: textAttributes)
        contentTextView.typingAttributes = newAttributes
    }
}

// MARK: Keyboard setup
extension EditNoteView {
    
    /// Switching between keyboard and text formatting menu
    func toggleInputView() {
        if !isCustomView {
            self.contentTextView.inputAccessoryView = nil
            self.contentTextView.inputView = self.formatMenu
            self.contentTextView.reloadInputViews()
        } else {
            self.contentTextView.inputAccessoryView = toolBar
            self.contentTextView.inputView = nil
            self.contentTextView.reloadInputViews()
        }
        
        isCustomView = !isCustomView
    }
    
    /// Update textview insets when keyaboard appears or disappears
    /// This is to prevent the keyboard from covering the text
    /// - Parameter sender: NSNotification
    @objc func updateTextView(sender: NSNotification) {
        guard let userInfo = sender.userInfo as? [String: Any],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
              else { return }

        if sender.name == UIResponder.keyboardWillHideNotification {
            contentTextView.contentInset = UIEdgeInsets.zero
        } else {
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 50, right: 0)
        }
    }

    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

// MARK: TextViewDelegate
extension EditNoteView: UITextViewDelegate {
    // Updating the formatting menu view according to the cursor position
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let attributes = editNoteController?.getTextAttributes(typingAttributes: textView.typingAttributes)
        else { return }
        formatMenu.updateButtons(with: attributes)
    }
}

// MARK: TextField delegate
extension EditNoteView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentTextView.becomeFirstResponder()
    }
}


// MARK: Pick image

extension EditNoteView {
    func uploadImage(image: UIImage) {
        let cursorPosition = contentTextView.selectedRange.location
        let scaleFactor = image.size.width / (contentTextView.frame.size.width - 10);
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(cgImage: image.cgImage!, scale: scaleFactor, orientation: .up)
        let imageString = NSAttributedString(attachment: textAttachment)
        contentTextView.textStorage.insert(imageString, at: cursorPosition)
    }
}
