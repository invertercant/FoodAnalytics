//
//  UIView +autolayoutTrace.swift
//  EatingApp
//
//  Created by Александр Савченко on 14.10.2024.
//

import UIKit

extension UIView{
    
    func autolayoutTrace(){
        print(self.value(forKey: "_autolayoutTrace"))
    }
    
}
