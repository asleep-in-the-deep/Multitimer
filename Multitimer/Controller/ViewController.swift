//
//  ViewController.swift
//  Multitimer
//
//  Created by Arina on 05.09.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private let settingsView = UIView()
    private let timerNameTextField = UITextField()
    private let timeTextField = UITextField()
    private let addTimerButton = UIButton()
    
    private let tableView = UITableView()
    
    private var timers: [OneTimer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        navigationItem.title = "Мульти таймер"
        
        setupSettingsView()
        hideKeyboardWhenTappedOutside()
        
        setTableView()
    }
    
    // MARK: - Settings View
    
    private func setupSettingsView() {
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsView)
        
        setSettingsViewConstraints()
        
        setTimerLabel()
        setTextField(textField: timerNameTextField, placeholder: "Название таймера", topAnchor: settingsView.topAnchor, topConstant: 50, keyboard: .default)
        setTextField(textField: timeTextField, placeholder: "Время", topAnchor: timerNameTextField.bottomAnchor, topConstant: 20, keyboard: .numberPad)
        setButton()
    }
    
    private func setSettingsViewConstraints() {
        let margins = view.layoutMarginsGuide
         NSLayoutConstraint.activate([
            settingsView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
         ])
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([ settingsView.topAnchor.constraint(equalToSystemSpacingBelow: safeArea.topAnchor, multiplier: 1.0),
            settingsView.heightAnchor.constraint(equalToConstant: 240.0)
        ])
    }
    
    // MARK: - Settings View Elements
    
    private func setTimerLabel() {
        let timerLabel = UILabel(frame: CGRect(x: 0, y: 10, width: 200, height: 21))
        timerLabel.text = "Добавление таймеров"
        timerLabel.textColor = .gray
        settingsView.addSubview(timerLabel)
    }
    
    private func setTextField(textField: UITextField, placeholder: String, topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, topConstant: CGFloat, keyboard: UIKeyboardType) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboard
        textField.delegate = self
        textField.becomeFirstResponder()
        
        settingsView.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        textField.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setButton() {
        addTimerButton.backgroundColor = .systemGray5
        addTimerButton.layer.cornerRadius = 5
        addTimerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        addTimerButton.setTitleColor(.systemBlue, for: .normal)
        addTimerButton.setTitle("Добавить", for: .normal)
        
        settingsView.addSubview(addTimerButton)
        
        addTimerButton.translatesAutoresizingMaskIntoConstraints = false
        addTimerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addTimerButton.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -20).isActive = true
        addTimerButton.widthAnchor.constraint(equalTo: settingsView.widthAnchor).isActive = true
        
        addTimerButton.addTarget(self, action: #selector(addTimer), for: .touchUpInside)
    }
    
    @objc private func addTimer(sender: UIButton!) {
        let timerName = timerNameTextField.text
        let timeString = timeTextField.text
        
        if timerName == "" || timeString == "" {
            self.showAlert(title: "Ошибка", message: "Необходимо заполнить все поля")
        } else {
            let time = Int(timeString!)
            self.timers.append(OneTimer(name: timerName!, time: time!))
            timers = timers.sorted(by: { $0.time > $1.time })
            self.tableView.reloadData()
            
            timerNameTextField.text?.removeAll()
            timeTextField.text?.removeAll()
        }
    }
    
    // MARK: - Keyboard hiding
    
    private  func hideKeyboardWhenTappedOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    // MARK: - Alert
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Закрыть", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard textField == timeTextField else { return true }
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

// MARK: - TableView Delegate and Data Source

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimerViewCell.self, forCellReuseIdentifier: "timerCell")
        tableView.estimatedRowHeight = 40
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: settingsView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath) as! TimerViewCell
        
        let timer = timers[indexPath.row]
        cell.setCell(timer: timer)
        
        cell.handler = { [weak self] (counter) in
            self?.timers[indexPath.row].time = counter
            
            if counter == 0 {
                self?.showAlert(title: "Время вышло", message: timer.name +  " завершился")
                self?.timers.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Таймеры"
    }
    
}
