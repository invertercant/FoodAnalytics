//
//  RetryFooterView.swift
//  EatingApp
//
//  Created by Александр Савченко on 12.10.2024.
//
import UIKit
import RxSwift
import RxGesture

struct RetryFooterVM {
    var title: String = ""
    var retry: String = ""
    let tapEvents: PublishSubject<Void> = PublishSubject()
}

extension RetryFooterVM: Equatable{
    
    static func == (lhs: RetryFooterVM, rhs: RetryFooterVM) -> Bool {
        var result = true
        result = lhs.title == rhs.title && result
        return result
    }
    
}

class RetryFooterView: UIView{
    
    var vm: RetryFooterVM = RetryFooterVM()
    var disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has been not implemented")
    }
    
    lazy var stackView: UIStackView = {
        let result = UIStackView()
        result.axis = .horizontal
        result.spacing = 2
        return result
    }()
    
    let retryAttributes: [NSAttributedString.Key: Any] = {
        var result: [NSAttributedString.Key: Any] = [:]
        let textStyle = TMTextStyleFactory().make(option: .body1Semibold)
        result = TextStyleTextAttributesConvertibleAdapter(textStyle: textStyle).makeAttributes()
        result[.foregroundColor] = AppColors.appBlue
        let paragraphStyle = result[.paragraphStyle] as? NSMutableParagraphStyle
        paragraphStyle?.alignment = .right
        return result
    }()
    
    let titleAttributes: [NSAttributedString.Key: Any] = {
        var result: [NSAttributedString.Key: Any] = [:]
        let textStyle = TMTextStyleFactory().make(option: .body1Semibold)
        result = TextStyleTextAttributesConvertibleAdapter(textStyle: textStyle).makeAttributes()
        result[.foregroundColor] = AppColors.title
        let paragraphStyle = result[.paragraphStyle] as? NSMutableParagraphStyle
        paragraphStyle?.alignment = .left
        return result
    }()
    
    var retryLabel: LineHeightedLabel = {
        let result = LineHeightedLabel()
        result.wrappedLabel.numberOfLines = 0
        return result
    }()
    
    var titleLabel: LineHeightedLabel = {
        let result = LineHeightedLabel()
        result.wrappedLabel.numberOfLines = 0
        return result
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    func initLayout(){
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(retryLabel)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
    }
    
    func setup(viewModel: RetryFooterVM){
        disposeBag = DisposeBag()
        self.vm = viewModel
        titleLabel.wrappedLabel.attributedText = NSAttributedString(string: viewModel.title, attributes: titleAttributes)
        retryLabel.wrappedLabel.attributedText = NSAttributedString(string: viewModel.retry, attributes: retryAttributes)
        retryLabel.rx.tapGesture().when(.recognized).subscribe(
            onNext: { [weak self] _ in
                self?.vm.tapEvents.onNext(())
            }
        )
        .disposed(by: disposeBag)
    }
    
}
