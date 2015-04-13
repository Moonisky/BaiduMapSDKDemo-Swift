//
//  BaseTableViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-2-17.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

/// Main.storyboard的主视图界面
class BaseTableViewController: UITableViewController {
    
    // MARK: - Table View 数据源方法实现
    
    // 设置tableView显示的行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDemoName.count
    }
    
    // 设置Table View单元格(cell)的显示样式
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        
        // 寻找tableView当中对应ID的复用单元格
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            // 如果不存在则新建一个对应ID的单元格
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        // 设定该单元格的标签文本
        cell!.textLabel?.text = arrayOfDemoName[indexPath.row]
        return cell!
    }
    
    // 设置Table View 单元格选中后的跳转，使用Segue跳转的方式，注意这里每个segue都设定了对应的Identifier。如果觉得麻烦的话，可以使用presentViewController，直接跳转到对应名称的view controller
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var segueName = arrayOfSceneName[indexPath.row] + "Segue"
        self.performSegueWithIdentifier(segueName, sender: self)
    
    }
    
    // MARK: - 内存管理
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
