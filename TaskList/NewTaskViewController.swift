import UIKit
import AudioToolbox
import Supabase

class NewTaskViewController: UIViewController {

    @IBOutlet weak var newTaskDateLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var selectedDate: Date? // Seçilen tarihi tutmak için bir değişken
    var alarmButton: UIButton? // Alarm butonunu referans almak için
    var flagButton: UIButton? // Flag butonunu referans almak için
    
    var passedDateText: String? // FirstViewController'dan gelen veri
    
    let supabaseUrl = URL(string: "https://nckdyawxkhjabqsaboub.supabase.co")!
    let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ja2R5YXd4a2hqYWJxc2Fib3ViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAwMTg3NjAsImV4cCI6MjAzNTU5NDc2MH0.74vvRucyln9xNV8G8i8c09VpemC_B1wlk67LssXrJ-g"
    var client: SupabaseClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FirstViewController'dan gelen veriyi newTaskDateLabel'a ata
        if let passedDateText = passedDateText {
            newTaskDateLabel.text = passedDateText
        }
        
        client = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
        
        textField.becomeFirstResponder() // Ekran göründüğünde klavyeyi açar
        
        setupTextField()
        setupToolbar()
    }
    
    private func setupTextField() {
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter task"
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20
        
        let calendarButton = createButton(withImage: "calendar", action: #selector(calendarButtonTapped))
        let alarmButton = createButton(withImage: "alarm", action: #selector(alarmButtonTapped))
        self.alarmButton = alarmButton
        AlarmManager.shared.setupAlarmButton(alarmButton: alarmButton)
        
        let flagButton = createButton(withImage: "flag", action: #selector(flagButtonTapped))
        self.flagButton = flagButton
        FlagManager.shared.setupFlagSelectionView(in: view, flagButton: flagButton)
        
        let checkmarkButton = createButton(withImage: "checkmark", action: #selector(checkmarkButtonTapped))
        
        stackView.addArrangedSubview(calendarButton)
        stackView.addArrangedSubview(alarmButton)
        stackView.addArrangedSubview(flagButton)
        stackView.addArrangedSubview(checkmarkButton)
        
        toolbar.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: toolbar.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor)
        ])
        
        textField.inputAccessoryView = toolbar
    }
    
    private func createButton(withImage systemName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc private func calendarButtonTapped() {
        print("Takvim butonu tıklandı")
        // Takvim butonu tıklandığında yapılacak işlemler
    }
    
    @objc private func alarmButtonTapped() {
        AlarmManager.shared.alarmButtonTapped()
    }
    
    @objc private func flagButtonTapped() {
        FlagManager.shared.flagButtonTapped()
    }
    
    @objc private func checkmarkButtonTapped() {
        print("Checkmark butonu tıklandı")
        guard let taskTitle = textField.text, !taskTitle.isEmpty else {
            print("Task title is empty")
            return
        }
        
        Task {
            do {
                try await newTaskDeneme(title: taskTitle)
            } catch {
                print("Error adding user: \(error.localizedDescription)")
            }
        }
    }
    
    struct NewTask: Codable {
        let id: UUID
        let title: String
    }

    func newTaskDeneme(title: String) async throws {
        let newTask = NewTask(id: UUID(), title: title)
        let response = try await client.from("tasks").insert([newTask]).execute()
        print("User added successfully: \(response)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //textField.becomeFirstResponder() // Ekran göründüğünde klavyeyi açar
    }
}
