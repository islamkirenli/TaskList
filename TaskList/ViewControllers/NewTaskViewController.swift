import UIKit
import AudioToolbox
import Supabase

class NewTaskViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var subTaskContentView: UIView!
    
    var alarmButton: UIButton?
    var flagButton: UIButton?
    var subtaskButton: UIButton? // Subtask butonunu referans olarak tutmak için
    
    let flagManager = FlagManager.shared
    var newTaskSelectedFlag = 0
    
    var calendarManager: CalendarManager!
    var newTaskSelectedDate: Date!
    var formattedDate: String!
    
    let supabaseUrl = URL(string: "https://nckdyawxkhjabqsaboub.supabase.co")!
    let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ja2R5YXd4a2hqYWJxc2Fib3ViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAwMTg3NjAsImV4cCI6MjAzNTU5NDc2MH0.74vvRucyln9xNV8G8i8c09VpemC_B1wlk67LssXrJ-g"
    var client: SupabaseClient!
    
    var textFields: [UITextField] = []
    var subTaskViewManager: SubTaskViewManager!
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    var toolbar: UIToolbar!
    
    var activeTextField: UITextField?
    var subtaskArray: [String] = [] // Subtask'ları tutacak dizi

    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
        
        calendarManager = CalendarManager(textField: textField)
        calendarManager.dateSelectedCallback = { [weak self] selectedDate in
            self?.dateSelected(date: selectedDate)
            self?.reactivateTextField()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFlagColorSelected(notification:)), name: .flagColorSelected, object: nil)
        
        setupTextField()
        setupToolbar()
        setDefaultDate()
                
        setupScrollView()
        setupStackView()
        subTaskViewManager = SubTaskViewManager(stackView: stackView, scrollView: scrollView, toolbar: toolbar, viewController: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .flagColorSelected, object: nil)
    }
    
    private func setupTextField() {
        textField.delegate = self
        textField.borderStyle = .none
        textField.placeholder = "Enter task"
        textField.inputAccessoryView = toolbar
        textField.font = UIFont.systemFont(ofSize: 20) // Font büyüklüğünü burada ayarlıyoruz
    }
    
    private func setupToolbar() {
        toolbar = createToolbar()
        textField.inputAccessoryView = toolbar
    }
    
    private func createToolbar() -> UIToolbar {
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
        
        let subtaskButton = createButton(withImage: "plus.square.on.square", action: #selector(subtaskButtonTapped(_:)))
        self.subtaskButton = subtaskButton // Referansı saklayın
        
        let checkmarkButton = createButton(withImage: "checkmark", action: #selector(checkmarkButtonTapped))
        
        stackView.addArrangedSubview(calendarButton)
        stackView.addArrangedSubview(alarmButton)
        stackView.addArrangedSubview(flagButton)
        stackView.addArrangedSubview(subtaskButton)
        stackView.addArrangedSubview(checkmarkButton)
        
        toolbar.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: toolbar.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor)
        ])
        
        return toolbar
    }
    
    private func createButton(withImage systemName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc private func calendarButtonTapped() {
        dismissKeyboard()
        calendarManager.showDatePicker(in: self.view)
    }
    
    @objc private func alarmButtonTapped() {
        AlarmManager.shared.alarmButtonTapped()
    }
    
    @objc private func flagButtonTapped() {
        FlagManager.shared.flagButtonTapped()
    }
    
    @objc private func subtaskButtonTapped(_ sender: UIButton) {
        subTaskViewManager.addView()
        
        // En son oluşturulan textfield'a odağı geçir
        if let latestTextField = subTaskViewManager.latestTextField {
            latestTextField.becomeFirstResponder()
        }
        
        // İkonu dolu olarak değiştir
        subtaskButton?.setImage(UIImage(systemName: "plus.square.on.square.fill"), for: .normal)
    }
    
    @objc private func checkmarkButtonTapped() {
        print("Checkmark butonu tıklandı")
        guard let taskTitle = textField.text, !taskTitle.isEmpty else {
            print("Task title is empty")
            return
        }
        
        // Subtask textfield'larından verileri topla
        let subtasks = subTaskViewManager.collectSubtaskTexts()
        
        Task {
            do {
                try await loadNewTasktoDB(title: taskTitle, subtasks: subtasks)
                // Veri tabanına kaydetme işlemi tamamlandıktan sonra ana ekrana dön
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                print("Error adding user: \(error.localizedDescription)")
            }
        }
    }
    
    struct NewTask: Codable {
        let id: UUID
        let title: String
        let taskDate: Date
        let taskDateString: String
        let flagIndex: Int
        let subTasks: String // Subtask'ları JSON formatında tutuyoruz
    }

    func loadNewTasktoDB(title: String, subtasks: [String]) async throws {
        // Subtasks dizisini JSON formatına çeviriyoruz
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(subtasks)
        let jsonSubtasks = String(data: jsonData, encoding: .utf8)!
        
        let newTask = NewTask(id: UUID(), title: title, taskDate: newTaskSelectedDate, taskDateString: formattedDate, flagIndex: newTaskSelectedFlag, subTasks: jsonSubtasks)
        let response = try await client.from("tasks").insert([newTask]).execute()
        print("User added successfully: \(response)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func dateSelected(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        if let dateWithoutTime = calendar.date(from: components) {
            newTaskSelectedDate = dateWithoutTime
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formatter.timeZone = TimeZone.autoupdatingCurrent
            formattedDate = formatter.string(from: dateWithoutTime)
            let newDateTest = formatter.date(from: formattedDate)
            
            print("Seçilen tarih: \(String(describing: newDateTest))")
            print("Seçilen tarih string: \(String(describing: formattedDate))")
        }
    }
    
    @objc func handleFlagColorSelected(notification: Notification) {
        if let userInfo = notification.userInfo, let selectedIndex = userInfo["selectedIndex"] as? Int {
            print("Seçilen bayrak indeksi: \(selectedIndex)")
            newTaskSelectedFlag = selectedIndex
        }
    }
    
    private func setDefaultDate() {
        let today = Date()
        dateSelected(date: today)
    }
     
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        subTaskContentView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: subTaskContentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: subTaskContentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: subTaskContentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: subTaskContentView.bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adjustSubTaskContentViewHeight()
    }

    private func adjustSubTaskContentViewHeight() {
        let toolbarHeight: CGFloat = 50
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        let contentViewHeight = view.frame.height - toolbarHeight - bottomPadding - textField.frame.height
        
        subTaskContentView.frame = CGRect(
            x: subTaskContentView.frame.origin.x,
            y: subTaskContentView.frame.origin.y,
            width: subTaskContentView.frame.width,
            height: contentViewHeight
        )
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func reactivateTextField() {
        if let lastView = stackView.arrangedSubviews.last,
           let textField = lastView.subviews.first(where: { $0 is UITextField }) as? UITextField {
            textField.becomeFirstResponder()
        } else {
            textField.becomeFirstResponder()
        }
    }
}

extension NewTaskViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if activeTextField == textField {
            activeTextField = nil
        }
    }
}
