//
//  RetryVC.swift
//  EatingApp
//
//  Created by Alexander Savchenko on 20.10.2024.
//

import UIKit
import RxSwift

class RetryVC: UIViewController {
    
    weak var retryView: RetryView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let retryView = RetryView()
        let retryVM = RetryViewVM(title: "Retry", subtitle: "Retry description", image: nil)
        retryView.setup(vm: retryVM)
        view.addSubview(retryView)
        retryView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.retryView = retryView
        view.backgroundColor = .blue
        //withExtendedLifetime(<#T##x: ~Copyable##~Copyable#>, <#T##body: () throws(Error) -> ~Copyable##() throws(Error) -> ~Copyable#>)
        
    }
}

