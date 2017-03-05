//
//  ViewController.swift
//  PocketBook
//
//  Created by 张嘉夫 on 2017/3/4.
//  Copyright © 2017年 张嘉夫. All rights reserved.
//

import UIKit
import RealmSwift

class Record: Object {
    dynamic var des: String = ""
    dynamic var num: Double = 0
    dynamic var time: Date!
}

class RecordViewController: UIViewController{

    var numberString = "0" {
        didSet {
            numberLabel.text = "¥\(numberString)"
        }
    }
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var aboveView: UIView!
    var numberKeyboardBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardView: RecordKeyboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 初始化自定义键盘
        let keyboardView = RecordKeyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        keyboardView.delegate = self // 键盘会通知视图控制器，在按下一个键的时候
        
        self.keyboardView = keyboardView
        view.addSubview(keyboardView)
        
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: keyboardView, attribute: .width, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: keyboardView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.5, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: keyboardView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        numberKeyboardBottomConstraint = NSLayoutConstraint(item: keyboardView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(numberKeyboardBottomConstraint)
        
        aboveView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: aboveView, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: aboveView, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: aboveView, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: aboveView, attribute: .bottom, relatedBy: .equal, toItem: keyboardView, attribute: .top, multiplier: 1, constant: 0))
        
        numberLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecordViewController.numberLabelTapped)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(RecordViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RecordViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberLabelTapped() {
        if numberKeyboardBottomConstraint.constant != 0 {
            descriptionTextField.resignFirstResponder()
            UIView.animate(withDuration: 0.3) {
                self.numberKeyboardBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if cancelButtonBottomConstraint.constant == 0{
                cancelButtonBottomConstraint.constant = keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
            if cancelButtonBottomConstraint.constant != 0{
                cancelButtonBottomConstraint.constant = 0
            }
    }
}

extension RecordViewController: RecordKeyboardDelegate {
    // 键盘 delegate 协议必须的方法
    func keyWasTapped(character: String) {
        
        if numberString == "0" {
            numberString = character
        }else {
            numberString = numberString.appending(character)
        }
       
    }
    func doneKeyWasTapped() {
        UIView.animate(withDuration: 0.3) {
            self.numberKeyboardBottomConstraint.constant = self.view.frame.size.height/2
            self.view.layoutIfNeeded()
        }
        descriptionTextField.becomeFirstResponder()
    }
    func digitKeyWasTapped() {
        if !numberString.contains(".") {
            numberString = numberString.appending(".")
        }
    }
    func deleteKeyWasTapped() {
        
        if numberString.characters.count == 1 {
            numberString = "0"
        }else {
            numberString = numberString.substring(to: numberString.index(before: numberString.endIndex))
        }
        
    }
}

extension RecordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if numberKeyboardBottomConstraint.constant == 0 {
            UIView.animate(withDuration: 0.3) {
                self.numberKeyboardBottomConstraint.constant = self.view.frame.size.height/2
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == descriptionTextField {
            let newRecord = Record()
            newRecord.des = textField.text ?? ""
            newRecord.num = Double(numberString)!
            newRecord.time = Date()
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(newRecord)
            }
            
            dismiss(animated: true, completion: nil)
        }
        return true
    }
}

