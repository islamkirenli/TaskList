import UIKit
import Supabase

struct Tasks: Decodable {
    let id: UUID
    let title: String
    let subTasks: String?
    let taskDate: Date?
    let taskDateString: String?
    let flagIndex: Int?
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var tomorrowView: UIView!
    @IBOutlet weak var thisWeekView: UIView!
    @IBOutlet weak var soonView: UIView!
    
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var taskNumberLabel: UILabel!
    
    @IBOutlet weak var tasksView: UIView!
    @IBOutlet weak var tasksTableView: UITableView!
    
    var currentEntityName: String = "TodayTasks" // Varsayılan entity
    
    var newTaskPlusButtonManager: NewTaskPlusButtonManager?
    
    var data: [Tasks] = []
    
    var taskTitle: String?
    
    let supabaseUrl = URL(string: "https://nckdyawxkhjabqsaboub.supabase.co")!
    let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ja2R5YXd4a2hqYWJxc2Fib3ViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAwMTg3NjAsImV4cCI6MjAzNTU5NDc2MH0.74vvRucyln9xNV8G8i8c09VpemC_B1wlk67LssXrJ-g"
    var client: SupabaseClient!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        client = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
        
        taskTimeLabel.text = "Today's Tasks"
        
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        
        let gestureRecognizerToday = UITapGestureRecognizer(target: self, action: #selector(todayViewTapped))
        todayView.addGestureRecognizer(gestureRecognizerToday)
        let gestureRecognizerTomorrow = UITapGestureRecognizer(target: self, action: #selector(tomorrowViewTapped))
        tomorrowView.addGestureRecognizer(gestureRecognizerTomorrow)
        let gestureRecognizerThisWeek = UITapGestureRecognizer(target: self, action: #selector(thisWeekViewTapped))
        thisWeekView.addGestureRecognizer(gestureRecognizerThisWeek)
        let gestureRecognizerSoon = UITapGestureRecognizer(target: self, action: #selector(soonViewTapped))
        soonView.addGestureRecognizer(gestureRecognizerSoon)
        
        newTaskPlusButtonManager = NewTaskPlusButtonManager(parentView: view, viewController: self) // ViewController referansı eklendi

        Task {
            await fetchData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await fetchData()
        }
    }
    
    @objc func todayViewTapped(){
        taskTimeLabel.text = "Today's Tasks"
        currentEntityName = "today_tasks"
        Task {
            await fetchData()
        }
    }
    
    @objc func tomorrowViewTapped(){
        taskTimeLabel.text = "Tomorrow's Tasks"
        currentEntityName = "tomorrow_tasks"
        Task {
            await fetchData()
        }
    }
    
    @objc func thisWeekViewTapped(){
        taskTimeLabel.text = "This Week's Tasks"
        currentEntityName = "this_week_tasks"
        Task {
            await fetchData()
        }
    }
    
    @objc func soonViewTapped(){
        taskTimeLabel.text = "Soon's Tasks"
        currentEntityName = "soon_tasks"
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        do {
            let response = try await client.from("tasks").select().execute()
            
            let decoder = JSONDecoder()
            
            // Custom Date Formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Tarih formatını veritabanınıza göre ayarlayın
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let decodedData = try decoder.decode([Tasks].self, from: response.data)
            self.data = decodedData
            
            DispatchQueue.main.async {
                self.tasksTableView.reloadData()
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let task = data[indexPath.row]
        let name = task.title
        
        var content = UIListContentConfiguration.cell()
        content.text = name
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = data[indexPath.row]
        taskTitle = task.title
        //let isChecked = task.value(forKeyPath: "isChecked") as? Bool ?? false
        print(data[indexPath.row])
        
        performSegue(withIdentifier: "toShowTaskVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowTaskVC" {
            if let destinationVC = segue.destination as? ShowTaskViewController {
                destinationVC.receivedTaskName = taskTitle
            }
        }
    }
}
