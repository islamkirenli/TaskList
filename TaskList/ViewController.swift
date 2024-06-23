//
//  ViewController.swift
//  TaskList
//
//  Created by islam kirenli on 20.06.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var tomorrowView: UIView!
    @IBOutlet weak var thisWeekView: UIView!
    @IBOutlet weak var soonView: UIView!
    
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var taskNumberLabel: UILabel!
    
    @IBOutlet weak var tasksView: UIView!
    @IBOutlet weak var tasksTableView: UITableView!
    
    var isChecked = [Bool](repeating: false, count: 20)

    
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
        
        NewTaskButton.setupNewTaskButton(in: view, target: self, action: #selector(newTaskButtonTapped))
    }
    
    @objc func todayViewTapped(){
        taskTimeLabel.text = "Today's Tasks"
    }
    
    @objc func tomorrowViewTapped(){
        taskTimeLabel.text = "Tomorrow's Tasks"
    }
    
    @objc func thisWeekViewTapped(){
        taskTimeLabel.text = "This Week's Tasks"
    }
    
    @objc func soonViewTapped(){
        taskTimeLabel.text = "Soon's Tasks"
    }
    
    @objc func newTaskButtonTapped() {
        print("New Task Button Tapped")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = UIListContentConfiguration.cell()
        content.text = "test"
        
        if isChecked[indexPath.row] {
            content.image = UIImage(systemName: "checkmark.square")
        } else {
            content.image = UIImage(systemName: "square")
        }  
        
        content.secondaryText = "Secondary text"
        content.imageProperties.tintColor = .systemBlue
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Seçilen satırın tiklenmiş durumunu değiştirme
        isChecked[indexPath.row] = !isChecked[indexPath.row]
        
        // Tabloyu güncelleme
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

