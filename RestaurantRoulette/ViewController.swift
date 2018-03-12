//
//  ViewController.swift
//  Restaurant Roulette
//
//  Created by Labuser on 4/2/17.
//  Copyright © 2017 wustl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var nav: UINavigationController!
    var menu: MenuViewController!
    var window: UIWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.nav = UINavigationController()
        self.menu = MenuViewController()
        nav.viewControllers = [menu]
        nav.navigationBar.isTranslucent = false
        self.window!.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    
}

