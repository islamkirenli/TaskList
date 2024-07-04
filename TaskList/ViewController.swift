import UIKit
import Supabase

struct Tasks: Decodable {
    let id: UUID
    let title: String
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
    
    var floatingButtonManager: FloatingButtonManager?
    
    var data: [Tasks] = []
    
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
        
        floatingButtonManager = FloatingButtonManager(parentView: view, viewController: self) // ViewController referansı eklendi

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        Task{
            await fetchData()
        }
        
    }
    
    @objc func todayViewTapped(){
        taskTimeLabel.text = "Today's Tasks"
        currentEntityName = "TodayTasks"
        Task{
            await fetchData()
        }
    }
    
    @objc func tomorrowViewTapped(){
        taskTimeLabel.text = "Tomorrow's Tasks"
        currentEntityName = "TomorrowTasks"
        Task{
            await fetchData()
        }
    }
    
    @objc func thisWeekViewTapped(){
        taskTimeLabel.text = "This Week's Tasks"
        currentEntityName = "ThisWeekTasks"
        Task{
            await fetchData()
        }
    }
    
    @objc func soonViewTapped(){
        taskTimeLabel.text = "Soon's Tasks"
        currentEntityName = "SoonTasks"
        Task{
            await fetchData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewTaskVC", let destinationVC = segue.destination as? NewTaskViewController {
            destinationVC.passedDateText = taskTimeLabel.text
        }
    }
    
    @objc func handleTap() {
        if floatingButtonManager?.additionalButtonsVisible == true {
            floatingButtonManager?.hideAdditionalButtons()
            floatingButtonManager?.removeBlurEffect()
        }
    }
    
    func fetchData() async {
        do {
            let response = try await client.from("tasks").select().execute()
            
            // response.data'yı JSONDecoder ile doğrudan ayrıştırıyoruz
            let decoder = JSONDecoder()
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
        //let isChecked = task.value(forKeyPath: "isChecked") as? Bool ?? false
    }
    
    
}
