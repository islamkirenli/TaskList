import UIKit

class SubTaskViewManager {
    var viewCount = 0
    let viewHeight: CGFloat = 50.0
    let stackView: UIStackView
    let scrollView: UIScrollView
    let toolbar: UIToolbar
    weak var viewController: NewTaskViewController?

    var latestTextField: UITextField? // En son oluşturulan textfield referansı

    init(stackView: UIStackView, scrollView: UIScrollView, toolbar: UIToolbar, viewController: NewTaskViewController) {
        self.stackView = stackView
        self.scrollView = scrollView
        self.toolbar = toolbar
        self.viewController = viewController
    }

    func addView() {
        viewCount += 1

        let newView = UIView()
        newView.backgroundColor = .red
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true

        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "Enter subtask"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.inputAccessoryView = toolbar
        textField.delegate = viewController
        textField.font = UIFont.systemFont(ofSize: 15)
        addBottomLine(to: textField)

        let iconImageView = UIImageView(image: UIImage(systemName: "arrow.turn.down.right"))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let deleteButton = UIButton(type: .custom)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteView(_:)), for: .touchUpInside)

        newView.addSubview(iconImageView)
        newView.addSubview(textField)
        newView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: newView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            textField.centerYAnchor.constraint(equalTo: newView.centerYAnchor),

            deleteButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: newView.trailingAnchor, constant: -10),
            deleteButton.centerYAnchor.constraint(equalTo: newView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),

            textField.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -10)
        ])

        stackView.addArrangedSubview(newView)

        if viewCount > 5 {
            scrollView.layoutIfNeeded()
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }

        // Textfield'ı viewController'daki textFields dizisine ekleyin
        viewController?.textFields.append(textField)

        // En son oluşturulan textfield referansını sakla ve odağı geç
        latestTextField = textField
        textField.becomeFirstResponder()
    }

    func addBottomLine(to textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
        textField.layer.masksToBounds = true
    }

    @objc func deleteView(_ sender: UIButton) {
        guard let viewToRemove = sender.superview else { return }
        viewToRemove.removeFromSuperview()
        viewCount -= 1

        // Silinen view'daki textfield'ı viewController'daki textFields dizisinden çıkarın
        if let textField = viewToRemove.subviews.first(where: { $0 is UITextField }) as? UITextField,
           let index = viewController?.textFields.firstIndex(of: textField) {
            viewController?.textFields.remove(at: index)
        }

        // Silme işleminden sonra en son oluşturulan textfield'a odağı geç
        if let lastView = stackView.arrangedSubviews.last,
           let textField = lastView.subviews.first(where: { $0 is UITextField }) as? UITextField {
            textField.becomeFirstResponder()
            latestTextField = textField
        } else {
            viewController?.textField.becomeFirstResponder()
            latestTextField = viewController?.textField
        }

        // Eğer hiç subtask kalmadıysa subtask butonunun ikonunu boş olarak değiştir
        if viewController?.textFields.isEmpty ?? true {
            viewController?.subtaskButton?.setImage(UIImage(systemName: "plus.square.on.square"), for: .normal)
        }

        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
    }

    func collectSubtaskTexts() -> [String] {
        return viewController?.textFields.compactMap { $0.text?.isEmpty == false ? $0.text : nil } ?? []
    }
}

