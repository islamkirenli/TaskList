/*import UIKit

class NewTaskViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var selectedDate: Date? // Seçilen tarihi tutmak için bir değişken
    var flagButton: UIBarButtonItem?
    var flagSelectionView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.becomeFirstResponder() // Ekran göründüğünde klavyeyi açar
        
        setupBackButton()
        setupTextField()
        setupToolbar()
        setupFlagSelectionView()
    }
    
    private func setupBackButton() {
        backButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        backButton.tintColor = .black
    }
    
    private func setupTextField() {
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter task"
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let calendarButton = UIBarButtonItem(
            image: UIImage(systemName: "calendar"),
            style: .plain,
            target: self,
            action: #selector(calendarButtonTapped)
        )
        let alarmButton = UIBarButtonItem(
            image: UIImage(systemName: "alarm"),
            style: .plain,
            target: self,
            action: #selector(alarmButtonTapped)
        )
        
        let flagButtonView = UIButton(type: .custom)
        flagButtonView.setImage(UIImage(systemName: "flag"), for: .normal)
        flagButtonView.addTarget(self, action: #selector(flagButtonTapped), for: .touchUpInside)
        flagButton = UIBarButtonItem(customView: flagButtonView)
        
        let checkmarkButton = UIBarButtonItem(
            image: UIImage(systemName: "checkmark"),
            style: .plain,
            target: self,
            action: #selector(checkmarkButtonTapped)
        )
        
        // Sabit boşluk örneği
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 80
        
        // Esnek boşluk örneği
        //let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Butonların sırasını ve aralarındaki boşlukları burada ayarlayın
        toolbar.setItems([calendarButton, fixedSpace, alarmButton, fixedSpace, flagButton!, fixedSpace, checkmarkButton], animated: false)
        
        textField.inputAccessoryView = toolbar
    }
    
    private func setupFlagSelectionView() {
        let flagView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 190))
        flagView.backgroundColor = UIColor(white: 0.9, alpha: 0.5) // Silik gri arka plan rengi
        flagView.layer.cornerRadius = 10
        flagView.isHidden = true
        view.addSubview(flagView)
        flagSelectionView = flagView
        
        let colors: [UIColor] = [.red, .orange, .yellow, .white]
        let systemNames = ["flag.fill", "flag.fill", "flag.fill", "flag.fill"]
        
        let buttonHeight: CGFloat = 40
        let buttonSpacing: CGFloat = 1
        
        for (index, color) in colors.enumerated() {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 10, y: CGFloat(index) * (buttonHeight + buttonSpacing) + 10, width: 40, height: buttonHeight)
            let image = UIImage(systemName: systemNames[index])?.withTintColor(color, renderingMode: .alwaysOriginal)
            button.setImage(image, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(flagColorSelected(_:)), for: .touchUpInside)
            flagView.addSubview(button)
        }
    }
    
    @objc private func calendarButtonTapped() {
        // Takvim butonu tıklandığında yapılacak işlemler
    }
    
    @objc private func alarmButtonTapped() {
        // Alarm butonu tıklandığında yapılacak işlemler
    }
    
    @objc private func flagButtonTapped() {
        if let flagView = flagSelectionView, let flagButton = flagButton?.customView {
            flagView.isHidden = !flagView.isHidden
            if !flagView.isHidden {
                // Flag view'i flagButton'un üstünde konumlandır
                let flagButtonFrame = flagButton.superview?.convert(flagButton.frame, to: view) ?? CGRect.zero
                flagView.frame.origin = CGPoint(x: flagButtonFrame.midX - flagView.frame.width / 2, y: flagButtonFrame.minY - flagView.frame.height - 10)
            }
        }
    }
    
    @objc private func flagColorSelected(_ sender: UIButton) {
        let colors: [UIColor] = [.red, .orange, .yellow, .white]
        let selectedColor = colors[sender.tag]
        if let flagButtonView = flagButton?.customView as? UIButton {
            let image = UIImage(systemName: "flag.fill")?.withTintColor(selectedColor, renderingMode: .alwaysOriginal)
            flagButtonView.setImage(image, for: .normal)
        }
        flagSelectionView?.isHidden = true
    }
    
    @objc private func checkmarkButtonTapped() {
        // Tik butonu tıklandığında yapılacak işlemler
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //textField.becomeFirstResponder() // Ekran göründüğünde klavyeyi açar
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
*/

import UIKit
import AudioToolbox

class NewTaskViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var selectedDate: Date? // Seçilen tarihi tutmak için bir değişken
    var flagButton: UIBarButtonItem?
    var flagSelectionView: UIView?
    var alarmButton: UIBarButtonItem? // Alarm butonunu referans almak için
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.becomeFirstResponder() // Ekran göründüğünde klavyeyi açar
        
        setupBackButton()
        setupTextField()
        setupToolbar()
        setupFlagSelectionView()
    }
    
    private func setupBackButton() {
        backButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        backButton.tintColor = .black
    }
    
    private func setupTextField() {
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter task"
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let calendarButton = UIBarButtonItem(
            image: UIImage(systemName: "calendar"),
            style: .plain,
            target: self,
            action: #selector(calendarButtonTapped)
        )
        
        let alarmButtonView = UIButton(type: .custom)
        alarmButtonView.setImage(UIImage(systemName: "alarm"), for: .normal)
        alarmButtonView.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(alarmButtonLongPressed(_:)))
        longPressRecognizer.minimumPressDuration = 0.5 // Uzun basma süresi (0.5 saniye)
        alarmButtonView.addGestureRecognizer(longPressRecognizer)
        alarmButton = UIBarButtonItem(customView: alarmButtonView)
        
        let flagButtonView = UIButton(type: .custom)
        flagButtonView.setImage(UIImage(systemName: "flag"), for: .normal)
        flagButtonView.addTarget(self, action: #selector(flagButtonTapped), for: .touchUpInside)
        flagButton = UIBarButtonItem(customView: flagButtonView)
        
        let checkmarkButton = UIBarButtonItem(
            image: UIImage(systemName: "checkmark"),
            style: .plain,
            target: self,
            action: #selector(checkmarkButtonTapped)
        )
        
        // Sabit boşluk örneği
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 80
        
        // Esnek boşluk örneği
        //let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Butonların sırasını ve aralarındaki boşlukları burada ayarlayın
        toolbar.setItems([calendarButton, fixedSpace, alarmButton!, fixedSpace, flagButton!, fixedSpace, checkmarkButton], animated: false)
        
        textField.inputAccessoryView = toolbar
    }
    
    private func setupFlagSelectionView() {
        let flagView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 190))
        flagView.backgroundColor = UIColor(white: 0.9, alpha: 0.5) // Silik gri arka plan rengi
        flagView.layer.cornerRadius = 10
        flagView.isHidden = true
        view.addSubview(flagView)
        flagSelectionView = flagView
        
        let colors: [UIColor] = [.red, .orange, .yellow, .white]
        let systemNames = ["flag.fill", "flag.fill", "flag.fill", "flag.fill"]
        
        let buttonHeight: CGFloat = 40
        let buttonSpacing: CGFloat = 1
        
        for (index, color) in colors.enumerated() {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 10, y: CGFloat(index) * (buttonHeight + buttonSpacing) + 10, width: 40, height: buttonHeight)
            let image = UIImage(systemName: systemNames[index])?.withTintColor(color, renderingMode: .alwaysOriginal)
            button.setImage(image, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(flagColorSelected(_:)), for: .touchUpInside)
            flagView.addSubview(button)
        }
    }
    
    @objc private func calendarButtonTapped() {
        // Takvim butonu tıklandığında yapılacak işlemler
    }
    
    @objc private func alarmButtonTapped() {
        showDatePicker()
    }
    
    @objc private func alarmButtonLongPressed(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            // Titreşim ver
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            // Alarmları iptal et
            AlarmScheduler.shared.cancelScheduledNotifications()
            
            // Alarm butonunun rengini sıfırla
            resetAlarmButtonColor()
        }
    }
    
    @objc private func flagButtonTapped() {
        if let flagView = flagSelectionView, let flagButton = flagButton?.customView {
            flagView.isHidden = !flagView.isHidden
            if (!flagView.isHidden) {
                // Flag view'i flagButton'un üstünde konumlandır
                let flagButtonFrame = flagButton.superview?.convert(flagButton.frame, to: view) ?? CGRect.zero
                flagView.frame.origin = CGPoint(x: flagButtonFrame.midX - flagView.frame.width / 2, y: flagButtonFrame.minY - flagView.frame.height - 10)
            }
        }
    }
    
    @objc private func flagColorSelected(_ sender: UIButton) {
        let colors: [UIColor] = [.red, .orange, .yellow, .white]
        let selectedColor = colors[sender.tag]
        if let flagButtonView = flagButton?.customView as? UIButton {
            let image = UIImage(systemName: "flag.fill")?.withTintColor(selectedColor, renderingMode: .alwaysOriginal)
            flagButtonView.setImage(image, for: .normal)
        }
        flagSelectionView?.isHidden = true
    }
    
    @objc private func checkmarkButtonTapped() {
        // Tik butonu tıklandığında yapılacak işlemler
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //textField.becomeFirstResponder() // Ekran göründüğünde klavyeyi açar
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        
        // Çerçeveyi küçült
        datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        
        let alertController = UIAlertController(title: "Select Date and Time", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(datePicker)
        
        // Yükseklik kısıtlaması
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertController.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        alertController.view.addConstraint(height)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.selectedDate = datePicker.date
            AlarmScheduler.shared.scheduleNotification(at: datePicker.date, withTitle: "Task Reminder", andBody: "It's time for your task!")
            self.updateAlarmButtonColor()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateAlarmButtonColor() {
        guard let alarmButton = self.alarmButton else { return }
        if let button = alarmButton.customView as? UIButton {
            let image = UIImage(systemName: "alarm.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
            button.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "alarm.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
            alarmButton.image = image
        }
    }
    
    private func resetAlarmButtonColor() {
        guard let alarmButton = self.alarmButton else { return }
        if let button = alarmButton.customView as? UIButton {
            let image = UIImage(systemName: "alarm")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            button.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "alarm")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            alarmButton.image = image
        }
    }
}
