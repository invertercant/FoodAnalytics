//
//  TransitionHandleable.swift
//  tmatic
//
//  Created by Александр Савченко on 11.11.2022.
//

import Foundation
import UIKit

enum TransitionType{
    case presentation(style: UIModalPresentationStyle?, presentingVC: UIViewController)
    case navigationStack
}

protocol TransitionHandleable{
    func handleTransition(transition: TransitionType, vc: UIViewController)
}
