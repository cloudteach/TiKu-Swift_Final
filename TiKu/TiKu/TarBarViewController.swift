//
//  TarBarViewController.swift
//  TiKu
//
//  Created by tiny on 2018/1/18.
//  Copyright © 2018年 tiny. All rights reserved.
//

import UIKit

class TarBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let main = MainViewController()
        main.tabBarItem = UITabBarItem.init(title: "主页", image: UIImage.init(named: ""), tag: 1)
        
        let about = AboutViewController()
        about.tabBarItem = UITabBarItem.init(title: "关于", image: UIImage.init(named: ""), tag: 2)
        
        self.viewControllers = [main,about]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
