//
//  AboutViewController.swift
//  TiKu
//
//  Created by tiny on 2018/1/18.
//  Copyright © 2018年 tiny. All rights reserved.
//

import UIKit

class AboutViewController: SuperViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableview : UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if(nil == cell) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = "暂无..."
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: sw, height: 60))
        view.backgroundColor = UIColor.white
        
        let labelTitle = UILabel(frame: CGRect(x: 12, y: 0, width: sw-24, height: view.frame.size.height))
        labelTitle.text = "欢迎关注作者的其他APP:"
        view.addSubview(labelTitle)
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview = UITableView(frame: CGRect(x: 0, y: 64, width: sw, height: sh-64), style:.plain)
        tableview.delegate = self
        tableview.dataSource = self
        
        self.view.addSubview(tableview)
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
