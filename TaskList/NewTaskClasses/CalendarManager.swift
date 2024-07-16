import UIKit

class CalendarManager {
    var datePicker: UIDatePicker!
    var datePickerContainer: UIView!
    var selectedDate: Date?
    var textFieldForKeyboard: UITextField
    var dateSelectedCallback: ((Date) -> Void)?

    init(textField: UITextField) {
        self.textFieldForKeyboard = textField
        setupDatePicker()
    }

    private func setupDatePicker() {
        // DatePicker Container görünümünü oluştur
        datePickerContainer = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 500))
        datePickerContainer.backgroundColor = .white
        datePickerContainer.layer.cornerRadius = 10
        datePickerContainer.layer.shadowOpacity = 0.3
        datePickerContainer.layer.shadowRadius = 5

        // DatePicker'ı oluştur
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        // Cancel butonu oluştur
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        // Save butonu oluştur
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        // DatePicker, Cancel ve Save butonlarını container'a ekle
        datePickerContainer.addSubview(datePicker)
        datePickerContainer.addSubview(cancelButton)
        datePickerContainer.addSubview(saveButton)

        // DatePicker, Cancel ve Save butonlarının constraints ayarları
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor, constant: 10),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor, constant: -10),
            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor, constant: 10),

            cancelButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor, constant: 20),
            
            saveButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor, constant: -20)
        ])

        // Başlangıçta görünmez yap
        datePickerContainer.isHidden = true
    }

    @objc private func hideDatePickerContainer() {
        datePickerContainer.isHidden = true
    }

    @objc private func cancelButtonTapped() {
        hideDatePickerContainer()
        textFieldForKeyboard.becomeFirstResponder() // Klavyeyi tekrar aç
    }

    @objc private func saveButtonTapped() {
        selectedDate = datePicker.date
        if let selectedDate = selectedDate {
            dateSelectedCallback?(selectedDate)
        }
        hideDatePickerContainer()
        textFieldForKeyboard.becomeFirstResponder() // Klavyeyi tekrar aç
    }

    func showDatePicker(in view: UIView) {
        if datePickerContainer.superview == nil {
            view.addSubview(datePickerContainer)
            datePickerContainer.center = view.center
        }
        datePickerContainer.isHidden = false
    }
}


