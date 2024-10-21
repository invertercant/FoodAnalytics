//
//  LoadingFooterView.swift
//  EatingApp
//
//  Created by Александр Савченко on 12.10.2024.
//
import UIKit

class LoadingFooterView: UIView {
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .systemGray
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has been not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    func initLayout(){
        
        self.backgroundColor = UIColor.clear
        addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        
    }
    
    
}

