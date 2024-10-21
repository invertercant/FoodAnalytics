//
//  LineHeightLabel.swift
//  EatingApp
//
//  Created by Александр Савченко on 09.10.2024.

import UIKit
import SnapKit

struct LineHeightVM{
    let text: String
    let attributes: [NSAttributedString.Key: Any]
}

class LineHeightedLabel: UIView {
    
    override init(frame: CGRect) {
        self.wrappedLabel = UILabel()
        super.init(frame: frame)
        initLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Inspecting the view
    let wrappedLabel: UILabel
    private var topYAxisConstraint: Constraint?
    
    private func initLayout() {
        
        addSubview(wrappedLabel)

        wrappedLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            self.topYAxisConstraint = $0.top.equalToSuperview().constraint
        }
    }
    
    func setVM(vm: LineHeightVM) {
        let paragraphStyle = vm.attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle
        if let lineSpacing = paragraphStyle?.lineSpacing{
            //topYAxisConstraint?.constant = -(lineSpacing)/2.0
            let offset = (lineSpacing/2.0).rounded(.down)
            topYAxisConstraint?.update(offset: offset)
        } else{
            topYAxisConstraint?.update(offset: 0)
            //topYAxisConstraint?.constant = 0
        }
        wrappedLabel.attributedText = NSAttributedString(string: vm.text, attributes: vm.attributes)
        wrappedLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        //UIView.exerciseAmbiguity(self)
        //self.autolayoutTrace()
        //constraintsAffectingLayout(for: .vertical)
    
    }
    
    
    
}

