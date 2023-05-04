//
//  ViewController.swift
//  reminderApp
//
//  Created by Aylin GÜNEŞ on 3.05.2023.
//

import UIKit
import UserNotifications


class ViewController: UIViewController {

    @IBOutlet var table: UITableView!
    
    var models = [MyReminder]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }

    @IBAction func didTabAdd(){
        // show add vc
    }
    
    
    @IBAction func didTabTest(){
        // fire test notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success {
                //schedule test
                self.scheduleTest()
            }
            else if let error = error{
            print("error")
            }
        })
        
    }
    func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello world"
        content.sound = .default
        content.body = "Body body body body body body this part can includes long text"
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, . minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if error != nil {
                print("something went wrong")
            }
        })
        
        
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        return cell
        
    }
    
}

struct MyReminder {
    
    let title: String
    let date: Date
    let idendifier: String
}

