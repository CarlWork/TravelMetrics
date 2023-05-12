
//  TabBarController.swift
//  TravelMetrics
//
//  Created by Carl Work on 4/28/23.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an instance of ConversionViewController
        let conversionViewController = ConversionViewController()
        conversionViewController.title = "Conversion"
        let conversionNavigationController = UINavigationController(rootViewController: conversionViewController)
        
        let currencyViewController = CurrencyViewController()
        currencyViewController.title = "Currency"
        let currencyNavigationController = UINavigationController(rootViewController: currencyViewController)
        
        // Set the view controller of the tab bar
        self.viewControllers = [conversionNavigationController, currencyNavigationController]
        
        // Set the tab bar item
        conversionNavigationController.tabBarItem = UITabBarItem(title: "Conversion", image: UIImage(systemName: "scalemass"), tag: 0)
        currencyNavigationController.tabBarItem = UITabBarItem(title: "Currency", image: UIImage(systemName: "dollarsign.circle"), tag: 1)
        
    }
}


// Create instances of all view controllers

//        let currencyViewController = CurrencyViewController()
//        currencyViewController.title = "Currency"
//        let currencyNavigationController = UINavigationController(rootViewController: currencyViewController)
//
//        let temperatureViewController = TemperatureViewController()
//        temperatureViewController.title = "Temperature"
//        let temperatureNavigationController = UINavigationController(rootViewController: temperatureViewController)
//
//        let weightViewController = WeightViewController()
//        weightViewController.title = "Weight"
//        let weightNavigationController = UINavigationController(rootViewController: weightViewController)
//
//        let distanceViewController = DistanceViewController()
//        distanceViewController.title = "Distance"
//        let distanceNavigationController = UINavigationController(rootViewController: distanceViewController)

// Set the view controllers of the tab bar

//        self.viewControllers = [currencyNavigationController, temperatureNavigationController, weightNavigationController, distanceNavigationController]

// Set the tab bar items

//        currencyNavigationController.tabBarItem = UITabBarItem(title: "Currency", image: UIImage(systemName: "dollarsign.circle"), tag: 0)
//        temperatureNavigationController.tabBarItem = UITabBarItem(title: "Temperature", image: UIImage(systemName: "thermometer"), tag: 1)
//        weightNavigationController.tabBarItem = UITabBarItem(title: "Weight", image: UIImage(systemName: "scalemass"), tag: 2)
//        distanceNavigationController.tabBarItem = UITabBarItem(title: "Distance", image: UIImage(systemName: "ruler"), tag: 3)
//    }
//}
