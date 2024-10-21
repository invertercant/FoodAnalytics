//
//  NavigationCoordinator.swift
//  ulug_campus
//
//  Created by invertercant_dev on 17/08/2019.
//  Copyright © 2019 invertercant_dev. All rights reserved.
//
import UIKit

class NavigationCoordinator: Coordinator{
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dismissCompletion: (() -> Void)?
    
    func start() {
        
    }
    
    func start(transitionType: TransitionType, animated: Bool = true){
        let vc = makeVC()
        handleTransition(transition: transitionType, vc: vc, animated: animated)
    }
    
    func makeVC() -> UIViewController{
        return UIViewController()
    }
    
    init() {
        self.navigationController = UINavigationController()
    }
    
    func handleChildCoordinatorRemove(_ child: Coordinator){
        print(#function + " should override")
    }
    
}

extension NavigationCoordinator{
    
    func handleTransition(transition: TransitionType, vc: UIViewController, animated: Bool = true){
        switch transition{
        case .navigationStack:
            navigationController.pushViewController(vc, animated: animated)
        case .presentation(let modalPresentationStyle, let presentingVC):
            if let modalPresentationStyle = modalPresentationStyle{
                vc.modalPresentationStyle = modalPresentationStyle
            }
            //navigationController.tmPresentedViewController = vc
            presentingVC.present(vc, animated: animated)
        }
    }
    
}

//class MainNavigationController: UINavigationController {
//    
//    var baseNavigationBarHeight: CGFloat = 0
//    //если мы презентуем его внутри уже презентованного контроллера
//    //почему то не заполняется свойство presented view controller
//    var tmPresentedViewController: UIViewController?
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        baseNavigationBarHeight = navigationBar.frame.height
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        return UIApplication.statusBarStyle
//    }
//    
//    //Pushes a view controller onto the receiver’s stack and updates the display.
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        
//        super.pushViewController(viewController, animated: animated)
//        topViewController?.navigationItem.backButtonDisplayMode = .minimal
//
//    }
//    
//    //Pops the top view controller from the navigation stack and updates the display.
//    override func popViewController(animated: Bool) -> UIViewController? {
//        self.navigationBar.shadowImage = nil
//        return super.popViewController(animated: animated)
//    }
//    
//    func showShareSheet(for url: URL, onDismiss: NonParamNoReturnClosure? = nil) {
//        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
//        activityController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
//            //doesn'r matter action completed or cancelled
//            onDismiss?()
//        }
//    }
//}
