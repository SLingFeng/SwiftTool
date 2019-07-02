//
//  LFCountDoown.swift
//  jsbf
//
//  Created by big on 2019/6/26.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFCountDownView: UIView {

    let cd = CountDown()
    
    let dayLabel =  UILabel(fontSize: 17, fontColor: .white, text: "00")
    let hourLabel =  UILabel(fontSize: 17, fontColor: .white, text: "00")
    let minuteLabel =  UILabel(fontSize: 17, fontColor: .white, text: "00")
    let secondLabel =  UILabel(fontSize: 17, fontColor: .white, text: "00")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.sd_addSubviews([dayLabel, hourLabel, minuteLabel, secondLabel])
        
        dayLabel.snp_makeConstraints({ make in
            make.centerY.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(30)
            make.height.equalTo(self)
            
        })
        hourLabel.snp_makeConstraints({ make in
            make.left.equalTo(dayLabel.snp_right).offset(0)
            make.size.equalTo(self.dayLabel)
        })
        minuteLabel.snp_makeConstraints({ make in
            make.left.equalTo(hourLabel.snp_right).offset(0)
            make.size.equalTo(self.dayLabel)
        })
        secondLabel.snp_makeConstraints({ make in
            make.left.equalTo(minuteLabel.snp_right).offset(0)
            make.size.equalTo(self.dayLabel)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cd.destoryTimer()
    }
    
    ///此方法用两个时间戳做参数进行倒计时
    func startLongLongStartStamp(_ strtLL: Int64, longlongFinishStamp finishLL: Int64) {
        weak var weakSelf = self
        cd.countDown(withStratTimeStamp: strtLL, finishTimeStamp: finishLL, complete: { day, hour, minute, second in
            weakSelf?.refreshUIDay(day, hour: hour, minute: minute, second: second)
        })
    }
    
    func refreshUIDay(_ day: Int, hour: Int, minute: Int, second: Int) {
        if day == 0 {//天
            dayLabel.text = "0:"
        } else {
            dayLabel.text = String(format: "%ld:", day)
        }
        if hour < 10 && hour != 0 {//小时
            hourLabel.text = String(format: "0%ld:", hour)
        } else {
            hourLabel.text = String(format: "%ld:", hour)
        }
        if minute < 10 {//分
            minuteLabel.text = String(format: "0%ld:", minute)
        } else {
            minuteLabel.text = String(format: "%ld:", minute)
        }
        if second < 10 {//秒
            secondLabel.text = String(format: "0%ld", second)
        } else {
            secondLabel.text = String(format: "%ld", second)
        }
    }
}
