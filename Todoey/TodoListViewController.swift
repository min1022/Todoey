//
//  ViewController.swift
//  Todoey
//
//  Created by GlobalHumanism on 2018. 12. 12..
//  Copyright © 2018년 GlobalHumanism. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let cellId = "cellId"
    
    let defaults = UserDefaults.standard
    
    

    var itemArray = ["Find Mike", "Buy Eggs", "Destroy demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Todoey"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(TodoCell.self, forCellReuseIdentifier: cellId)
//        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = .white
        
        naviTabAdd()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {//데이터가 nil일시 충돌날 수 도 있으므로 if let으로 옵셔널 바인딩
        
            itemArray = items
        
        }
    }
    
    
    
    //MARK: Add new items
    func naviTabAdd() {
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(cellAdd(_:)))
        
        navigationItem.setRightBarButtonItems([addBtn], animated: true)
    }
    
    @objc func cellAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //alert.add ...에 접근 가능
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        } //클로져 안에서 사용하므로 self.를 써줘야함
        
        alert.addTextField { (alertTextField) in //클로져 생성
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        } //얼러트 팝업에 텍스트뷰 삽입
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    //Mark - tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        
        return cell
    }
    
    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }//셀 체크
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class TodoCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
