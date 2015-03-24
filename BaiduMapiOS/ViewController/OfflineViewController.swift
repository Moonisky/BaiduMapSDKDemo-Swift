//
//  OfflineViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-8.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController, BMKMapViewDelegate, BMKOfflineMapDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var txf_cityName: UITextField!
    @IBOutlet var lbl_cityID: UILabel!
    @IBOutlet var lbl_downloadRatio: UILabel!
    @IBOutlet var seg_manager: UISegmentedControl!
    @IBOutlet var table_plainView: UITableView!
    @IBOutlet var table_groupView: UITableView!
    
    // 根据城市名检索城市 ID
    @IBAction func btn_Search(sender: UIButton) {
        // 根据城市名获取城市信息，得到城市 ID
        var city = offlineMap.searchCity(txf_cityName.text)
        if city.count > 0 {
            var oneCity = city[0] as BMKOLSearchRecord
            lbl_cityID.text = "ID:\(oneCity.cityID)"
            cityID = oneCity.cityID
        }
    }
    // 扫描离线包
    @IBAction func btn_Import(sender: UIButton) {
        offlineMap.scan(true)
    }
    
    // 开始下载离线包
    @IBAction func btn_download(sender: UIButton) {
        if cityID != nil {
            offlineMap.start(cityID)
        }
    }
    // 停止下载离线包
    @IBAction func btn_stop(sender: UIButton) {
        if cityID != nil {
            offlineMap.pause(cityID)
        }
    }
    // 删除本地离线包
    @IBAction func btn_delete(sender: UIButton) {
        if cityID != nil {
            offlineMap.remove(cityID)
            cityID = nil
        }
    }
    // 城市列表/下载管理切换
    @IBAction func tableViewChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            table_groupView.hidden = false
            table_plainView.hidden = true
            table_groupView.reloadData()
        case 1:
            table_groupView.hidden = true
            table_plainView.hidden = false
            // 获取各城市离线地图更新信息
            if let info = offlineMap.getAllUpdateInfo() {
                localDownloadMapInfo = info as [BMKOLUpdateElement]
            }else {
                localDownloadMapInfo = Array(count: 0, repeatedValue: BMKOLUpdateElement())
            }
            table_plainView.reloadData()
        default:
            break
        }
    }
    
    /// 百度地图视图
    var mapView: BMKMapView!
    /// 热门城市
    var hotCityData: [BMKOLSearchRecord]!
    /// 全国支持离线地图的城市
    var offlineCityData: [BMKOLSearchRecord]!
    /// 本地下载的离线地图
    var localDownloadMapInfo: [BMKOLUpdateElement]!
    /// 离线地图
    var offlineMap: BMKOfflineMap!
    /// 城市 ID
    var cityID: Int32!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[12]
        
        // 初始化离线地图服务
        offlineMap = BMKOfflineMap()
        // 获取热门城市
        hotCityData = offlineMap.getHotCityList() as [BMKOLSearchRecord]
        // 获取支持离线下载城市列表
        offlineCityData = offlineMap.getOfflineCityList() as [BMKOLSearchRecord]
        // 获取离线地图信息
        if let info = offlineMap.getAllUpdateInfo() {
            localDownloadMapInfo = info as [BMKOLUpdateElement]
        }else {
            localDownloadMapInfo = Array(count: 0, repeatedValue: BMKOLUpdateElement())
        }
        table_groupView.hidden = false
        table_plainView.hidden = true
        
        // 界面初始化
        seg_manager.selectedSegmentIndex = 0
        mapView = BMKMapView()
    }
    
    // 离线地图 delegate，用于获取通知
    func onGetOfflineMapState(type: Int32, withState state: Int32) {
        if type == 0 {
            // ID 为 state 的城市正在下载或更新，开始后会回调此类型
            var updateInfo: BMKOLUpdateElement
            if let info = offlineMap.getUpdateInfo(state) {
                updateInfo = offlineMap.getUpdateInfo(state)
                if let info = offlineMap.getAllUpdateInfo() {
                    localDownloadMapInfo = info as [BMKOLUpdateElement]
                }else {
                    localDownloadMapInfo = Array(count: 0, repeatedValue: BMKOLUpdateElement())
                }
                dispatch_async(dispatch_get_main_queue(), {self.table_plainView.reloadData()})
                NSLog("城市名：\(updateInfo.cityName)，下载比例：\(updateInfo.ratio)")
            }else {
                return
            }
            table_plainView.reloadData()
        }else if type == 4 {
            // ID 为 state 的城市有新版本，可调用 update 接口进行更新
            var updateInfo = offlineMap.getUpdateInfo(state)
            NSLog("是否有更新\(updateInfo.update)")
        }else if type == 2 {
            // 正在解压第 state 个离线包，导入时会回调此类型
        } else if type == 1 {
            // 检测到 state 个离线包，开始导入时会回调此类型
            NSLog("检测到\(state)个离线包！")
            if state == 0 {
                showImportMessage(state)
            }
        }else if type == 3 {
            // 有 state 个错误包，导入完成后会回调此类型
            NSLog("有\(state)个离线包导入错误")
        }else if type == 5 {
            NSLog("成功导入\(state)个离线包")
            // 导入成功 state 个离线包，导入成功后会回调此类型
            showImportMessage(state)
        }
    }
    
    // 导入提示框
    func showImportMessage(count: Int32) {
        var alertView = UIAlertController(title: "导入离线地图", message: "成功导入离线地图包个数:\(count)", preferredStyle: .Alert)
        var okaction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
        alertView.addAction(okaction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    // MARK: - 表格协议实现
    
    // 定义表中有几个分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == table_groupView {
            return 2
        }else {
            return 1
        }
    }
    
    // 定义分组的标题
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == table_groupView {
            // 定义每个分组的标题
            var provinceName = ""
            switch section {
            case 0:
                provinceName = "热门城市"
            case 1:
                provinceName = "全国"
            default:
                provinceName = ""
            }
            return provinceName
        }
        return nil
    }
    
    // 定义每个分组中有几行单元格
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table_groupView {
            switch section {
            case 0:
                return hotCityData.count
            case 1:
                return offlineCityData.count
            default:
                return 0
            }
        }else if tableView == table_plainView {
            return localDownloadMapInfo.count
        }
        return 0
    }
    
    // 定义单元格样式填充数据
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "OfflineMapCityCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        if tableView == table_groupView {
            // 热门城市列表
            if indexPath.section == 0 {
                var item = hotCityData[indexPath.row] as BMKOLSearchRecord
                cell?.textLabel?.text = "\(item.cityName)(\(item.cityID))"
                // 转换包大小
                var packSize = getDataSizeString(item.size)
                var sizeLabel = UILabel(frame: CGRectMake(250, 0, 60, 40))
                sizeLabel.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
                sizeLabel.text = packSize
                sizeLabel.backgroundColor = UIColor.clearColor()
                cell?.accessoryView = sizeLabel
            }
                // 支持离线下载城市列表
            else if indexPath.section == 1 {
                var item = offlineCityData[indexPath.row] as BMKOLSearchRecord
                cell?.textLabel?.text = "\(item.cityName)(\(item.cityID))"
                // 转换包大小
                var packSize = getDataSizeString(item.size)
                var sizeLabel = UILabel(frame: CGRectMake(250, 0, 60, 40))
                sizeLabel.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
                sizeLabel.text = packSize
                sizeLabel.backgroundColor = UIColor.clearColor()
                cell?.accessoryView = sizeLabel
            }
        }
        else {
            if localDownloadMapInfo != nil  {
                var item = localDownloadMapInfo[indexPath.row] as BMKOLUpdateElement
                // 单元格右侧文字
                var packSize = getDataSizeString(item.size)
                var sizeLabel = UILabel(frame: CGRectMake(250, 0, 110, 40))
                sizeLabel.backgroundColor = UIColor.clearColor()
                sizeLabel.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
                
                if item.ratio == 100{
                    sizeLabel.text = packSize
                }else{
                    var currentSize = getDataSizeString(item.size * item.ratio / 100)
                    sizeLabel.text = currentSize + "/" + packSize
                }
                if item.update {
                    sizeLabel.text = "可更新"
                    sizeLabel.textColor = UIColor.redColor()
                }
                
                cell?.textLabel?.text = "\(item.cityName)"
                cell?.accessoryView = sizeLabel
            }else {
                cell?.textLabel?.text = ""
            }
        }
        return cell!
    }
    
    // 是否允许表格进行编辑操作
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView == table_groupView {
            return false
        }else {
            return true
        }
    }
    
    // 提交编辑列表的结果
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // 删除 Poi
            if tableView == table_plainView {
                var item = localDownloadMapInfo[indexPath.row] as BMKOLUpdateElement
                // 删除指定城市 ID 的离线地图
                offlineMap.remove(item.cityID)
                // 将此城市的离线地图信息从数组中删除
                localDownloadMapInfo.removeAtIndex(indexPath.row)
                table_plainView.reloadData()
            }
        }
    }
    
    // 表格的行选择操作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if tableView == table_plainView {
            var item = localDownloadMapInfo[indexPath.row] as BMKOLUpdateElement
            println(item.update)
            if item.ratio == 100 {
                // 跳转到地图查看页面进行地图更新操作
                var offlineMapViewController = OfflineMapViewController()
                offlineMapViewController.title = "查看离线地图"
                offlineMapViewController.cityID = item.cityID
                offlineMapViewController.offlineServiceOfMapview = offlineMap
                var customLeftBarButtonItem = UIBarButtonItem()
                customLeftBarButtonItem.title = "返回"
                self.navigationItem.backBarButtonItem = customLeftBarButtonItem
                self.navigationController?.pushViewController(offlineMapViewController, animated: true)
            }
            else if item.ratio < 100 {
                // 弹出提示框
                lbl_cityID.text = "ID:\(item.cityID)"
                cityID = item.cityID
                txf_cityName.text = item.cityName
                lbl_downloadRatio.text = "已下载:\(item.ratio)"
                var alertView = UIAlertController(title: "提示", message: "该离线地图未完全下载，请继续下载！", preferredStyle: .Alert)
                var okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }else {
            // 获得当前选中的城市信息
            if indexPath.section == 0 {
                var item = hotCityData[indexPath.row] as BMKOLSearchRecord
                NSLog("热门城市：\(item.cityName)(\(item.cityID))--包大小：\(getDataSizeString(item.size))")
            }else if indexPath.section == 1 {
                var item = offlineCityData[indexPath.row] as BMKOLSearchRecord
                // 显示子单元格
                if item.childCities != nil && item.childCities.count > 0 {
                    for childitem in item.childCities as [BMKOLSearchRecord] {
                        var tempString = "\(childitem.cityName)(\(childitem.cityID))"
                        // 转换包大小
                        var tempPackSize = getDataSizeString(childitem.size)
                        NSLog("支持离线包城市：\(tempString)--包大小：\(tempPackSize)")
                    }
                }
            }
        }
    }
    
    // MARK: 包大小转换工具（将包大小转换成合适的单位）
    func getDataSizeString(nSize: Int32) -> String {
        var string = ""
        if nSize < 1024 {
            string = "\(nSize)B"
        }else if nSize < 1048576 {
            string = "\(nSize/1024)K"
        }else if nSize < 1073741824 {
            if nSize % 1048576 == 0 {
                string = "\(nSize/1048576)M"
            }else {
                var decimal = 0 // 小数
                var decimalString = ""
                decimal =  Int(nSize) % 1048576
                decimal /= 1024
                
                if decimal < 10 {
                    decimalString = "0"
                }else if decimal >= 10 && decimal < 100 {
                    var i = decimal / 10
                    if i >= 5 {
                        decimalString = "1"
                    }else {
                        decimalString = "0"
                    }
                }
                else if decimal >= 100 && decimal < 1024 {
                    var i = decimal / 100
                    if i >= 5 {
                        decimal = i + 1
                        
                        if decimal >= 10 {
                            decimal = 9
                        }
                        decimalString = "\(decimal)"
                    }
                    else {
                        decimalString = "\(i)"
                    }
                }
                if decimalString == "" {
                    string = "\(nSize / 1048576)Mss"
                }else {
                    string = "\(nSize / 1048576).\(decimalString)M"
                }
            }
        }
            // > 1G
        else {
            string = "\(nSize / 1073741824)Gb"
        }
        
        return string
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        offlineMap.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        offlineMap.delegate = nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

