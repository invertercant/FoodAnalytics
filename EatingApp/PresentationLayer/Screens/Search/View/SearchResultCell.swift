//
//  SearchResultCell.swift
//  EatingApp
//
//  Created by Александр Савченко on 24.09.2024.
//

import UIKit
import SnapKit
import Reusable

protocol FoodItemVMConvertible{
    func foodItemVM() -> FoodItemVM
}

struct FoodItemVM{
    var id: Int = 0
    var title: String = ""
    var energy: Float?
    var brand: String?
    
    var subtitle: String{
        var strings: [String?] = []
        strings.append(brand)
        if let energy = energy{
            strings.append(String(format: "%.0f", energy) + " kcal")
        }
        return strings.compactMap{$0}.joined(separator: " - ")
    }
    
}

extension FoodItemVM: Equatable{
    
    static func == (lhs: FoodItemVM, rhs: FoodItemVM) -> Bool {
        return lhs.id == rhs.id
    }

}

class SearchResultCell: UITableViewCell, Reusable {

    var vm: FoodItemVM?
    var cardView: SearchResultCardView = SearchResultCardView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initLayout(){
        
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(cardView)
        
        let insets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(insets)
        }
        cardView.backgroundColor = AppColors.cardBackground
        cardView.layer.cornerRadius = 16
        
    }
    
    func setup(vm: FoodItemVM){
        self.vm = vm
        cardView.setup(vm: vm)
    }
    
    

}
