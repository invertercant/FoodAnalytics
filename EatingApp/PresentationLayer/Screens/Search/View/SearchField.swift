//
//  AttendanceDetailsSearchField.swift
//  Campus
//
//  Created by Александр Савченко on 27.12.2023.
//  Copyright © 2023 MGOU. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct TextFieldVM{
    var placeholder: String
    var textEvents: BehaviorSubject<String> = BehaviorSubject(value: "")
}

class SearchField: UIView{
    
    let disposeBag = DisposeBag()
    var vm: TextFieldVM?
    
    var imageView: UIImageView = {
        let result = UIImageView()
        result.contentMode = .scaleAspectFit
        result.image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        result.tintColor = AppColors.imageTint
        return result
    }()
    
    lazy var textField: UITextField = {
        let result = UITextField()
        result.font = .systemFont(ofSize: 16)
        result.textColor = UIColor.black
        result.backgroundColor = AppColors.searchBackground
        result.layer.cornerRadius = 20
        result.leftViewMode = .always
        
        let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = UIColor.gray
        iconView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 40, height: 40))
        iconContainerView.addSubview(iconView)
        
        result.leftView = iconContainerView
        return result
    }()
    
    lazy var container: UIView = {
        
        
        var result = UIView()
        
        result.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
        return result
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
        setReaction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout(){
        
        self.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
    }
    
    func setReaction(){

        textField.rx.controlEvent([.editingChanged])
            .withLatestFrom(textField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                self?.vm?.textEvents.onNext(text)
            })
            .disposed(by: disposeBag)

    }
    
    func setup(vm: TextFieldVM){
        self.vm = vm
        textField.placeholder = vm.placeholder
        textField.text = try? vm.textEvents.value()
    }
    
}

extension SearchField: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
}
