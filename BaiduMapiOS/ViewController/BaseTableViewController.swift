//
//  BaseTableViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-2-17.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

// Main.storyboard的主视图界面
class BaseTableViewController: UITableViewController {
    
    // MARK: - Table View 数据源方法实现
    
    // 设置Table View的行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDemoName.count
    }
    
    // 设置Table View单元格的显示样式
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        cell!.textLabel?.text = arrayOfDemoName[indexPath.row]
        return cell!
    }
    
    // 设置Table View 单元格选中后的跳转
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var segueName = arrayOfSceneName[indexPath.row] + "Segue"
        self.performSegueWithIdentifier(segueName, sender: self)
    
    }
    
    // MARK: - 内存管理
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
