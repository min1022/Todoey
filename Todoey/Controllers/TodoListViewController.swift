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
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Todoey"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(TodoCell.self, forCellReuseIdentifier: cellId)
//        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = .white
        
        naviTabAdd()
        
        let newItem = Item()
        newItem.title = "ㄴㅇㄹㅇ"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "find mike"
        itemArray.append(newItem2)
    
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {//데이터가 nil일시 충돌날 수 도 있으므로 if let으로 옵셔널 바인딩, 아이템의 어레이를 되찾아옴 -> as? [Item]
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
           
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
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

        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //-->Ternary operator<--
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none //밑의 if문과 같은 기능
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done//셀 체크
        
        tableView.reloadData()
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
