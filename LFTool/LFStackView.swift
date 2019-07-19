//
//  LFStackView.swift
//  jsbf
//
//  Created by big on 2019/6/24.
//  Copyright © 2019 SADF. All rights reserved.
//

import UIKit

class LFStackView: UIView {

    var sv: UIStackView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    class func arrangedLabels(text: [String], fontSize: CGFloat, color: UIColor, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, rate: [CGFloat], noLayout:[Bool] = []) -> LFStackView {
    
        var arr: [UILabel] = []
        for i in 0..<text.count {
            let label = UILabel(fontSize: fontSize, fontColor: color, text: text[i])
            arr.append(label)
        }
        let view = LFStackView(arrangedLabels: arr, axis: axis, distribution: distribution, alignment: alignment, rate: rate, noLayout: noLayout)

        return view
    }
    
    init(arrangedLabels views: [UILabel], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, rate: [CGFloat], noLayout:[Bool] = []) {
        super.init(frame: .zero)
        
        let sv = LFStackView.create(arrangedSubviews: views, axis: axis, distribution: distribution, alignment: alignment, rate: rate, noLayout: noLayout)
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
    
//    class func create(arrangedSubviews views: [UIView], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, rate: [CGFloat]) -> UIStackView {
//        
//        
//        
//        let sv = UIStackView(arrangedSubviews: views)
//        if views.count == rate.count {
//            for i in 0..<views.count {
//                let v = views[i]
//                let w = rate[i]
//                v.snp.makeConstraints({ (make) in
//                    make.width.equalTo(sv).multipliedBy(w)
//                })
//            }
//        }
//
//        sv.axis = axis
//        sv.distribution = distribution
//        sv.alignment = alignment
//        
//        return sv
//    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - views: <#views description#>
    ///   - axis: <#axis description#>
    ///   - distribution: <#distribution description#>
    ///   - alignment: <#alignment description#>
    ///   - rate: <#rate description#>
    ///   - noLayout: false 默认约束
    /// - Returns: <#return value description#>
    class func create(arrangedSubviews views: [UIView], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, rate: [CGFloat], noLayout:[Bool] = []) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: views)
        if views.count == rate.count {
            for i in 0..<views.count {
                let v = views[i]
                let wh = rate[i]
                if noLayout.count <= 0 {
                    v.snp.makeConstraints({ (make) in
                        if axis == .horizontal {
                            make.width.equalTo(sv).multipliedBy(wh).priority(999)
                            make.height.equalTo(sv)
                        }
                        if axis == .vertical {
                            make.width.equalTo(sv)
                            make.height.equalTo(sv).multipliedBy(wh)
                        }
                    })
                    continue
                }
                let layout = noLayout[i]
                if layout {
                    v.snp.makeConstraints({ (make) in
                        if axis == .horizontal {
                            make.width.equalTo(sv).multipliedBy(wh)
                            make.height.equalTo(sv)
                        }
                        if axis == .vertical {
                            make.width.equalTo(sv)
                            make.height.equalTo(sv).multipliedBy(wh)
                        }
                    })
                }
            }
        }
        
        sv.axis = axis
        sv.distribution = distribution
        sv.alignment = alignment
        
        return sv
    }
    //返回
    class func createSelf(arrangedSubviews views: [UIView], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, rate: [CGFloat], noLayout:[Bool] = []) -> LFStackView {
        
        let view = LFStackView(frame: .zero)
        
        let sv = UIStackView(arrangedSubviews: views)
        view.sv = sv
        view.addSubview(sv)
        
        sv.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        
        view.sv = sv
        
        if views.count == rate.count {
            for i in 0..<views.count {
                let v = views[i]
                let wh = rate[i]
                if noLayout.count <= 0 {
                    v.snp.makeConstraints({ (make) in
                        if axis == .horizontal {
                            make.width.equalTo(sv).multipliedBy(wh)
                            make.height.equalTo(sv)
                        }
                        if axis == .vertical {
                            make.width.equalTo(sv)
                            make.height.equalTo(sv).multipliedBy(wh)
                        }
                    })
                    continue
                }
                let layout = noLayout[i]
                if layout {
                    v.snp.makeConstraints({ (make) in
                        if axis == .horizontal {
                            make.width.equalTo(sv).multipliedBy(wh)
                            make.height.equalTo(sv)
                        }
                        if axis == .vertical {
                            make.width.equalTo(sv)
                            make.height.equalTo(sv).multipliedBy(wh)
                        }
                    })
                }
            }
        }
        
        sv.axis = axis
        sv.distribution = distribution
        sv.alignment = alignment
        
        return view
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func replaceText(text: [String]) {
        guard text.count == sv?.arrangedSubviews.count else {
            return
        }
        for i in 0..<(sv?.arrangedSubviews.count ?? 0) {
            let v = sv?.arrangedSubviews[i]
            if let label: UILabel = v as? UILabel {
                label.text = text[i]
            }
        }
    }

}
