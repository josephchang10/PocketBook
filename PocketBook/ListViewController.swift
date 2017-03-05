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

    lazy var records: Results<Record> = {
        return try! Realm().objects(Record.self).sorted(byKeyPath: "time", ascending: false)
    }()
    var token: NotificationToken?
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let actionSheet = UIAlertController(title: nil, message: "Delete?", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                try! self.realm.write {
                    self.realm.delete(self.records[indexPath.row])
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        } else {
            print("couldn't find index path")
        }
        
    }
}
