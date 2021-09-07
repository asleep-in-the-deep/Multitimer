//
//  TimerViewCell.swift
//  Multitimer
//
//  Created by Arina on 06.09.2021.
//

import UIKit

class TimerViewCell: UITableViewCell {
        
    private var timerNameLabel = UILabel()
    private var timeLabel = UILabel()
        
    var handler: ((Int)->())?
    
    private var timer: Timer?
    private var counter = 0 {
        didSet {
            DispatchQueue.main.async {
                self.timeLabel.text = self.timeFormatted(totalSeconds: self.counter)
                self.handler?(self.counter)
            }
        }
    }
    
    // MARK: - Initializators
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setTimerNameLabel()
        setTimeLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell elements
    
    private func setLabel(label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        self.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setTimerNameLabel() {
        setLabel(label: timerNameLabel)
        timerNameLabel.textAlignment = .left
        timerNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
    }
    
    private func setTimeLabel() {
        setLabel(label: timeLabel)
        timeLabel.textAlignment = .right
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    // MARK: - Setting cell
    
    func setCell(timer: OneTimer) {
        self.counter = timer.time
        timerNameLabel.text = timer.name
        createTimer(seconds: timer.time)
    }
    
    // MARK: - Timer
    
    private func createTimer(seconds: Int) {
        timeLabel.text = timeFormatted(totalSeconds: counter)
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.timeLabel.text = self.timeFormatted(totalSeconds: self.counter)
            if self.counter > 0 {
                self.counter -= 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func timeFormatted(totalSeconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(totalSeconds))!
        
        if totalSeconds < 60 && totalSeconds >= 10 {
            return "0:" + formattedString
        } else if totalSeconds < 10 {
            return "0:0" + formattedString
        }
        return formattedString
    }

}
