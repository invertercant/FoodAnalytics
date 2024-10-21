//
//  Coordinator.swift
//  ulug_campus
//
//  Created by invertercant_dev on 17/08/2019.
//  Copyright © 2019 invertercant_dev. All rights reserved.
//

//import UIKit

protocol Coordinator: AnyObject {
    
    var parentCoordinator: Coordinator? {get set}
    var childCoordinators: [Coordinator] { get set }
    func start()
    func didChildCoordinatorFinish(_ child: Coordinator)
    func handleChildCoordinatorRemove(_ child: Coordinator)
    
}

extension Coordinator{
    
    func didChildCoordinatorFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                handleChildCoordinatorRemove(child)
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func handleChildCoordinatorRemove(_ child: Coordinator){
        
    }
    
    func addChild(coordinator: Coordinator, setParent: Bool = true){
        childCoordinators.append(coordinator)
        if setParent{
            coordinator.parentCoordinator = self
        }
    }
    
}
