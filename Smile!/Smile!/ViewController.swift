//
//  ViewController.swift
//  Smile!
//
//  Created by Виктор on 23.04.2023.
//

import UIKit
import UserNotifications
import RiveRuntime

class ViewController: UIViewController, UIApplicationDelegate, UNUserNotificationCenterDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let intervals = Array(1...24)
    let ac = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
    let center = UNUserNotificationCenter.current()
    @IBOutlet var mainTextLabel: UILabel!
    @IBOutlet var changeHoursLabel: UILabel!
    @IBOutlet var donationLabel: UILabel!
    var bgAnim = RiveViewModel(fileName: "background\(Int.random(in: 1..<4))")
    var phrases: [String] = []
    var selectedInterval = 1
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Настройка центра уведомлений
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted && error == nil {
                // Разрешение на отправку уведомлений получено
                print("Разрешение на отправку уведомлений получено")
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        loadData()
        loadPhrases()
        showRandomPhrase()
        scheduleNotifications()
        pickerSys()
        donationLabelSys()
        
        print("Уведомление приходит через \(selectedInterval)")
    }
    
    
    func setBackgroundColor() {
        let riveView = bgAnim.createRiveView()
        
        view.addSubview(riveView)
        view.sendSubviewToBack(riveView)
        riveView.frame = view.frame
    }
    
    func loadPhrases() {
        if let path = Bundle.main.path(forResource: "output", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                phrases = json?["phrases"] as? [String] ?? []
            } catch {
                print("Error loading phrases: \(error.localizedDescription)")
            }
        }
    }
    
    func showRandomPhrase() {
        let randomIndex = Int(arc4random_uniform(UInt32(phrases.count)))
        let randomPhrase = phrases[randomIndex]
        mainTextLabel.text = randomPhrase
    }
    
    func showRandomNotificaionPhrase() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(phrases.count)))
        let randomPhrase = phrases[randomIndex]
        return randomPhrase
    }
    
    func scheduleNotifications() {
        center.getPendingNotificationRequests { [self] requests in
            if requests.isEmpty {
                center.requestAuthorization(options: [.alert, .sound]) { [self] granted, error in
                    if granted && error == nil {
                        let content = UNMutableNotificationContent()
                        content.title = "Хочу тебе напомнить..."
                        content.body = self.showRandomNotificaionPhrase()
                        content.sound = UNNotificationSound.default
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(3600 * selectedInterval), repeats: true)
                        
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content,trigger: trigger)
                        
                        center.add(request) { [self] error in
                            if let error = error {
                                print("Ошибка при добавлении уведомления: \(error)")
                            } else {
                                print("Уведомление успешно добавлено!")
                                
                                center.getPendingNotificationRequests { requests in
                                    print("Список запросов на отправку уведомлений: \(requests)")
                                }
                            }
                        }
                    }
                }
            } else {
                print("Ожидаются другие уведомления, нельзя отправить новое")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Уведомление получено в фоновом режиме")
        completionHandler()
    }
    
    func pickerSys() {
        let pickerView = UIPickerView(frame: CGRect(x: 60, y: -36, width: 250, height: 100))
        pickerView.delegate = self
        ac.view.addSubview(pickerView)
        let doneAction = UIAlertAction(title: "Готово", style: .default) {(action) in
            self.selectedInterval = self.intervals[pickerView.selectedRow(inComponent: 0)]
            self.saveData()
            self.center.removeAllPendingNotificationRequests()
            self.scheduleNotifications()
            print(self.selectedInterval)
        }
        ac.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        ac.addAction(cancelAction)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showIntervalPicker))
        changeHoursLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func donationLabelSys() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(donationLabelTapped))
        donationLabel.addGestureRecognizer(tapGesture)
    }
    
    func saveData() {
        let defaults = UserDefaults.standard
        defaults.set(selectedInterval, forKey: "selectedInt")
        
        // Сохраняем изменения
        defaults.synchronize()
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["selectedInt": 1]) // По умолчанию 1
        
        // Получаем сохраненный Int из UserDefaults
        selectedInterval = defaults.integer(forKey: "selectedInt")
    }
    
    func pickerView(_ hourPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(intervals[row])
    }
    
    func numberOfComponents(in hourPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ hourPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return intervals.count
    }
    
    @objc func showIntervalPicker() {
        present(ac, animated: true)
    }
    
    @objc func donationLabelTapped() {
        if let url = URL(string: "https://donate.qiwi.com/payin/mrdiz") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
