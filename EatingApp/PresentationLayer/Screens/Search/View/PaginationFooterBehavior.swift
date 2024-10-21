//
//  PaginationFooterBehavior.swift
//  EatingApp
//
//  Created by Alexander Savchenko on 18.10.2024.
//
import UIKit
import RxSwift

struct PaginationFooterControlVM{
    var showRetry: Bool
    var showLoading: Bool
}

class PaginationFooterBehavior {

    var footerRetryView = RetryFooterView()
    var footerLoadingView = LoadingFooterView()
    
    let disposeBag = DisposeBag()
    weak var tableView: UITableView?
    let controlSequence: Observable<PaginationFooterControlVM>
    let supportSequence: Observable<RetryFooterVM>?
    
    internal init(tableView: UITableView?, controlSequence: Observable<PaginationFooterControlVM>, supportSequence: Observable<RetryFooterVM>? = nil) {
        self.tableView = tableView
        self.controlSequence = controlSequence
        self.supportSequence = supportSequence
        setReaction()
    }
    
    func setReaction() {
        controlSequence
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vm in
                guard let self = self else {return}
                if vm.showRetry {
                    self.footerRetryView.frame.size = footerRetryView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    self.tableView?.tableFooterView = footerRetryView
                } else if vm.showLoading {
                    self.footerLoadingView.frame.size = footerLoadingView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    self.tableView?.tableFooterView = footerLoadingView
                } else{
                    self.tableView?.tableFooterView = nil
                }
            })
            .disposed(by: disposeBag)
        
        supportSequence?.distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vm in
                self?.footerRetryView.setup(viewModel: vm)
            })
            .disposed(by: disposeBag)
    }
    
}
