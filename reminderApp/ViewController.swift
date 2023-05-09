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
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else{
            return
        }
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title , body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date, idendifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, . minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                    if error != nil {
                        print("something went wrong")
                    }
                })
                
            }
            
        }
        navigationController?.pushViewController(vc , animated: true)
    }
    
    
    @IBAction func didTabTest(){
        // fire test notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success {
                //schedule test
                self.scheduleTest()
            }
            else if error != nil {
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
        let date = models[indexPath.row].date
        
        let formetter = DateFormatter()
        formetter.dateFormat = "MMM, dd, YYY"
        cell.detailTextLabel?.text = formetter.string(from: date)
        return cell
        
    }
    
}

struct MyReminder {
    
    let title: String
    let date: Date
    let idendifier: String
}

