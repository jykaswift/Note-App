//
//  FormatMenu.swift
//  Notes
//
//  Created by Евгений Борисов on 28.01.2024.
//

import UIKit



class FormatMenu: UIView {
    
    weak var parentView: EditNoteView?
    private lazy var fontSizes: [Int: CGFloat] = [0: 24, 1: 16, 2: 12]
    private lazy var formatLabel: UILabel = {
        let formatLabel = UILabel()
        formatLabel.text = "Format"
        formatLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        formatLabel.translatesAutoresizingMaskIntoConstraints = false
        return formatLabel
    }()
    
    private lazy var fontSizeControl = {
        let fontSizeControl = UISegmentedControl(items: [
            "Large".image(withAttributes: [.font: UIFont.systemFont(ofSize: fontSizes[0]!)])!,
            "Medium".image(withAttributes: [.font: UIFont.systemFont(ofSize: fontSizes[1]!)])!,
            "Small".image(withAttributes: [.font: UIFont.systemFont(ofSize: fontSizes[2]!)])!,
        ])
        fontSizeControl.translatesAutoresizingMaskIntoConstraints = false
        fontSizeControl.selectedSegmentIndex = 1
        return fontSizeControl
    }()
    
    private lazy var closeButton: UIButton = {
        let closeAction = UIAction {[unowned self] _ in
            self.parentView?.updateAttributesWith(textAttributes: self.getTextAttributes())
            self.parentView?.toggleInputView()
        }
        let closeButton = UIButton(type: .close, primaryAction: closeAction)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    
    private lazy var boldButton = FormatButton(image: UIImage(systemName: "bold"))
    private lazy var italicButton = FormatButton(image: UIImage(systemName: "italic"))
    private lazy var underlineButton = FormatButton(image: UIImage(systemName: "underline"))
    
    private lazy var buttonBar: UIStackView = {
        let buttonBar = UIStackView()
        buttonBar.addArrangedSubview(boldButton)
        buttonBar.addArrangedSubview(italicButton)
        buttonBar.addArrangedSubview(underlineButton)
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.axis = .horizontal
        buttonBar.distribution = .fillEqually
        buttonBar.spacing = 5
        return buttonBar
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMenu()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getTextAttributes() -> TextAttributes {
        return TextAttributes(
            fontSize: fontSizes[fontSizeControl.selectedSegmentIndex]!,
            isBold: boldButton.isSelected,
            isItalic: italicButton.isSelected,
            isUnderline: underlineButton.isSelected)
    }
    
    func updateButtons(with textAttributes: TextAttributes) {
        for (key, dictionaryValue) in fontSizes {
            if textAttributes.fontSize == dictionaryValue {
                fontSizeControl.selectedSegmentIndex = key
            }
        }
        boldButton.isSelected = textAttributes.isBold
        italicButton.isSelected = textAttributes.isItalic
        underlineButton.isSelected = textAttributes.isUnderline
    }
    
    
    
    private func setupMenu() {
        backgroundColor = .white
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 15.0
        layer.shadowColor = UIColor.black.cgColor
        frame = CGRect(origin: .zero, size: CGSize(width: .zero, height: 200))
        addSubview(formatLabel)
        addSubview(buttonBar)
        addSubview(fontSizeControl)
        addSubview(closeButton)
        setupLayout()
        
    }
    
    private func setupLayout() {
        
        let sideMargin: CGFloat = 10
        let topMargin: CGFloat = 15
        
        NSLayoutConstraint.activate([
            formatLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideMargin),
            formatLabel.topAnchor.constraint(equalTo: topAnchor, constant: topMargin),
        ])
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: sideMargin),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideMargin),
        ])
        
        NSLayoutConstraint.activate([
            fontSizeControl.topAnchor.constraint(equalTo: formatLabel.bottomAnchor, constant: topMargin),
            fontSizeControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideMargin),
            fontSizeControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideMargin),
        ])
        
        NSLayoutConstraint.activate([
            buttonBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideMargin),
            buttonBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideMargin),
            buttonBar.topAnchor.constraint(equalTo: fontSizeControl.bottomAnchor, constant: topMargin),
            buttonBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }
    
}

// MARK: Convert string into image
extension String {
    /// Converting a string to an image. This is necessary to display a list of font sizes
    /// - Parameters:
    ///   - attributes: [NSAttributedString.Key: Any] type,  dictionary of text attributes
    ///   - size: CGSize type, image size
    /// - Returns: UIImage
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: .zero, size: size),
                                    withAttributes: attributes)
        }
    }
}
