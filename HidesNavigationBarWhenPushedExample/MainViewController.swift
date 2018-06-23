//
//  MainViewController.swift
//  HidesNavigationBarWhenPushedExample
//
//  Created by Danil Gontovnik on 23/06/2018.
//  Copyright © 2018 Danil Gontovnik. All rights reserved.
//

import UIKit

final class MainViewController: ViewController {
    
    // MARK: - Vars
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
    }

    // MARK: - Methods
    
    @IBAction func presentWithLargeNavigationBar(_ sender: Any) {
        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        navigationController.viewControllers.first?.title = "Large Navigation Bar"
        navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func presentWithRegularNavigationBar(_ sender: Any) {
        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        navigationController.viewControllers.first?.title = "Regular Navigation Bar"
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func pushWithHiddenNavigationBar(_ sender: Any) {
        let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.title = "Hidden Navigation Bar"
        mainViewController.hidesNavigationBarWhenPushed = true
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    @IBAction func push(_ sender: Any) {
        let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.title = "Pushed"
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}
