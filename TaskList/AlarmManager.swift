import UIKit
import AudioToolbox
import UserNotifications

class AlarmManager {
    static let shared = AlarmManager()
    
    private init() {}
    
    var alarmButton: UIButton?
    var selectedDate: Date?
    
    func setupAlarmButton(alarmButton: UIButton) {
        self.alarmButton = alarmButton
        
        // Alarm button için uzun basma tanılayıcı ekleyin
        let alarmLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(alarmButtonLongPressed(_:)))
        alarmLongPressRecognizer.minimumPressDuration = 0.5 // Uzun basma süresi (0.5 saniye)
        alarmButton.addGestureRecognizer(alarmLongPressRecognizer)
    }
    
    @objc func alarmButtonTapped() {
        print("Alarm butonu tıklandı")
        showDatePicker()
    }
    
    @objc func alarmButtonLongPressed(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            print("Alarm butonuna uzun basıldı")
            // Titreşim ver
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            // Alarmları iptal et
            AlarmScheduler.shared.cancelScheduledNotifications()
            
            // Alarm butonunun rengini sıfırla
            resetAlarmButtonColor()
        }
    }
    
    private func showDatePicker() {
        guard let alarmButton = self.alarmButton, let view = alarmButton.superview else { return }
        
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
        
        if let viewController = view.window?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func updateAlarmButtonColor() {
        guard let alarmButton = self.alarmButton else { return }
        let image = UIImage(systemName: "alarm.fill")?.withTintColor(.green, renderingMode: .alwaysOriginal)
        alarmButton.setImage(image, for: .normal)
    }
    
    func resetAlarmButtonColor() {
        guard let alarmButton = self.alarmButton else { return }
        let image = UIImage(systemName: "alarm")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        alarmButton.setImage(image, for: .normal)
    }
}

class AlarmScheduler {
    
    static let shared = AlarmScheduler()
    
    private init() {
        requestNotificationPermission()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
    func scheduleNotification(at date: Date, withTitle title: String, andBody body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date), repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        })
    }
    
    func cancelScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

