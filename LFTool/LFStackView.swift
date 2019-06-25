//
//  LFStackView.swift
//  jsbf
//
//  Created by big on 2019/6/24.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFStackView: UIView {

    var sv: UIStackView!
    
    class func arrangedLabels(text: [String], fontSize: CGFloat, color: UIColor, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, rate: [CGFloat]) -> LFStackView {
    
        var arr: [UILabel] = []
        for i in 0..<text.count {
            let label = UILabel(fontSize: fontSize, fontColor: color, text: text[i])
            arr.append(label)
        }
        let view = LFStackView(arrangedLabels: arr, axis: axis, distribution: distribution, alignment: alignment, rate: rate)

        return view
    }
    
    init(arrangedLabels views: [UILabel], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, rate: [CGFloat]) {
        super.init(frame: .zero)
        
        let sv = LFStackView.create(arrangedSubviews: views, axis: axis, distribution: distribution, alignment: alignment, rate: rate)
        self.addSubview(sv)
        sv.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        sv.arrangedSubviews.forEach { (v) in
            if let x: UILabel = v as? UILabel {
                x.textAlignment = .center
            }
        }
        self.sv = sv
    }
    
    class func create(arrangedSubviews views: [UIView], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, rate: [CGFloat]) -> UIStackView {
        
        
        
        let sv = UIStackView(arrangedSubviews: views)
        if views.count == rate.count {
            for i in 0..<views.count {
                let v = views[i]
                let w = rate[i]
                v.snp.makeConstraints({ (make) in
                    make.width.equalTo(sv).multipliedBy(w)
                })
            }
        }

        sv.axis = axis
        sv.distribution = distribution
        sv.alignment = alignment
        
        return sv
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func replaceText(text: [String]) {
        guard text.count == sv.arrangedSubviews.count else {
            return
        }
        for i in 0..<sv.arrangedSubviews.count {
            let v = sv.arrangedSubviews[i]
            if let label: UILabel = v {
                label.text = text[i]
            }
        }
    }

}
