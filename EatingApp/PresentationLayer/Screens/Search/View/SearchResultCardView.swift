//
//  SearchResultCardView.swift
//  EatingApp
//
//  Created by Александр Савченко on 24.09.2024.
//

import UIKit

class SearchResultCardView: UIView {
    
    let titleAttributes: [NSAttributedString.Key: Any] = {
        var result: [NSAttributedString.Key: Any] = [:]
        let textStyle = TMTextStyleFactory().make(option: .body1Semibold)
        result = TextStyleTextAttributesConvertibleAdapter(textStyle: textStyle).makeAttributes()
        result[.foregroundColor] = AppColors.title
        return result
    }()
    
    let subtitleAttributes: [NSAttributedString.Key: Any] = {
        var result: [NSAttributedString.Key: Any] = [:]
        let textStyle = TMTextStyleFactory().make(option: .body1Semibold)
        result = TextStyleTextAttributesConvertibleAdapter(textStyle: textStyle).makeAttributes()
        result[.foregroundColor] = AppColors.subtitle
        return result
    }()
    
    lazy var stackView: UIStackView = {
        let result = UIStackView()
        result.axis = .vertical
        result.spacing = 2
        return result
    }()
    
    var titleLabel: LineHeightedLabel = {
        let result = LineHeightedLabel()
        result.wrappedLabel.numberOfLines = 0
        return result
    }()
    
    var subtitleLabel: LineHeightedLabel = {
        let result = LineHeightedLabel()
        result.wrappedLabel.numberOfLines = 0
        return result
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has been not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    func initLayout(){
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        subtitleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
    }
    
    func setup(vm: FoodItemVM){
        titleLabel.setVM(vm: LineHeightVM(text: vm.title, attributes: titleAttributes))
        subtitleLabel.setVM(vm: LineHeightVM(text: vm.subtitle, attributes: subtitleAttributes))
    }

}
