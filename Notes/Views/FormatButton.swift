//
//  FormatButton.swift
//  Notes
//
//  Created by Евгений Борисов on 28.01.2024.
//

import UIKit

class FormatButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                tintColor = .white
                backgroundColor = .systemOrange
            } else {
                tintColor = .black
                backgroundColor = .systemGray5
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    convenience init(image: UIImage?) {
        self.init()
        setImage(image?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
    }
    
    private func setupButton() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray5
        tintColor = .black
        addTarget(self, action: #selector(onFormatButtonTapped), for: .touchUpInside)
    }
    
    @objc func onFormatButtonTapped() {
        isSelected = !isSelected
    }
}
