//
//  ListViewController.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/5.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit
import RealmSwift
import DateToolsSwift

class ListViewController: UIViewController {

    var filter: Category? {
        didSet {
            if let filter = filter {
                records = realm.objects(Record.self).filter("category == %@", filter).sorted(byKeyPath: "time", ascending: false)
            }else {
                records = realm.objects(Record.self).sorted(byKeyPath: "time", ascending: false)
            }
        }
    }
    var records: Results<Record>! {
        didSet {
            collectionView.reloadData()
            reloadSum()
            
        }
    }
    var sum = 0.0
    var todaySum = 0.0
    
    func reloadSum() {
        sum = 0.0
        todaySum = 0.0
        let startOfDay = Calendar.current.startOfDay(for: Date())
        for record in records {
            sum += record.num
            if startOfDay < record.time {
                todaySum += record.num
            }
        }
        sumLabel.text = "汇总 ￥\(sum)\n今日 ￥\(todaySum)"
    }
    
    var categorys: Results<Category>!
    var token: NotificationToken?
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        records = realm.objects(Record.self).sorted(byKeyPath: "time", ascending: false)
        categorys = realm.objects(Category.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.applicationDidBecomeActive), name: NSNotification.Name(rawValue: "DidBecomeActive"), object: nil)
        
        token = records.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                collectionView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                }, completion: { _ in })
                self?.reloadSum()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }
    
    deinit {
        token?.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applicationDidBecomeActive() {
        if isViewLoaded && (view.window != nil) {
            performSegue(withIdentifier: "AddRecord", sender: nil)
        }
    }
    
    @IBAction func filt(_ sender: Any) {
        let actionSheet = UIAlertController(title: "筛选", message: "选择一个类别", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "全部", style: .default, handler: { (action) in
            self.filter = nil
        }))
        for category in categorys {
            actionSheet.addAction(UIAlertAction(title: category.content, style: .default, handler: { (action) in
                self.filter = category
            }))
        }
        present(actionSheet, animated: true, completion: nil)
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

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return records.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let record = records[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as! RecordCollectionViewCell
        cell.numLabel.text = "¥\(record.num)"
        cell.desLabel.text = record.des
        cell.timeLabel.text = record.time.shortTimeAgoSinceNow
        
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(ListViewController.cellLongPressed)))
        
        return cell
    }
    
    func cellLongPressed(gesture : UILongPressGestureRecognizer!) {
        
        if gesture.state != .ended {
            return
        }
        let p = gesture.location(in: self.collectionView)
        
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            let record = self.records[indexPath.row]
            let actionSheet = UIAlertController(title: nil, message: "Action?", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                let editVC = EditRecordViewController()
                editVC.record = record
                let nav = UINavigationController(rootViewController: editVC)
                self.present(nav, animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                try! self.realm.write {
                    self.realm.delete(record)
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        } else {
            print("couldn't find index path")
        }
        
    }
}
