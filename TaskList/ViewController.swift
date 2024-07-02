import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var tomorrowView: UIView!
    @IBOutlet weak var thisWeekView: UIView!
    @IBOutlet weak var soonView: UIView!
    
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var taskNumberLabel: UILabel!
    
    @IBOutlet weak var tasksView: UIView!
    @IBOutlet weak var tasksTableView: UITableView!
    
    var tasks: [NSManagedObject] = []
    var currentEntityName: String = "TodayTasks" // Varsayılan entity
    
    var floatingButtonManager: FloatingButtonManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
    
    @objc func todayViewTapped(){
        taskTimeLabel.text = "Today's Tasks"
        currentEntityName = "TodayTasks"
    }
    
    @objc func tomorrowViewTapped(){
        taskTimeLabel.text = "Tomorrow's Tasks"
        currentEntityName = "TomorrowTasks"
    }
    
    @objc func thisWeekViewTapped(){
        taskTimeLabel.text = "This Week's Tasks"
        currentEntityName = "ThisWeekTasks"
    }
    
    @objc func soonViewTapped(){
        taskTimeLabel.text = "Soon's Tasks"
        currentEntityName = "SoonTasks"
    }
    
    @objc func handleTap() {
        if floatingButtonManager?.additionalButtonsVisible == true {
            floatingButtonManager?.hideAdditionalButtons()
            floatingButtonManager?.removeBlurEffect()
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let task = tasks[indexPath.row]
        let name = task.value(forKeyPath: "taskName") as? String
        let isChecked = task.value(forKeyPath: "isChecked") as? Bool ?? false
        
        var content = UIListContentConfiguration.cell()
        content.text = name
        
        // Boş kare veya tikli kare belirleme
        if isChecked {
            content.image = UIImage(systemName: "checkmark.square")
        } else {
            content.image = UIImage(systemName: "square")
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let isChecked = task.value(forKeyPath: "isChecked") as? Bool ?? false
    }
    
    
}

