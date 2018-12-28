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
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")//영속 코어 데이터 파일 경로
    //fisrt.에서 append 메소드 불러와서 새로운 커스텀 plist 만들기
    //유저 홈디렉토리 (현재 앱에 아이템 저장하는 장소)
    //documents/ 폴더 안에 plist 생성
    //items.plist에 Item 클래스의 프로퍼티를 적용
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        print(dataFilePath)
        
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
    
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {//데이터가 nil일시 충돌날 수 도 있으므로 if let으로 옵셔널 바인딩, 아이템의 어레이를 되찾아옴 -> as? [Item]
//            itemArray = items
//        }
        
        loadItems()
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
            self.saveItems()
        } //클로져 안에서 사용하므로 self를 써줘야함
        
        alert.addTextField { (alertTextField) in //클로져 생성
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        } //얼러트 팝업에 텍스트뷰 삽입
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods (아이템 저장)
    func saveItems() {
        
        let encoder = PropertyListEncoder()// 새 프로퍼티 리스트 인코더
        
        do {
            let data = try encoder.encode(itemArray) //데이터 array -> propertyList로 인코딩
            try data.write(to: dataFilePath!) //에러 쓰로우 할 수도 있어서 try사용
            //클로져 빠져나왔기 때문에 self안써도 됨
            
        } catch {
            print("Error encoding item array. \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
        //메소드 결과를 옵셔널로 나오게 하기 위해 trY? 사용
        //안전한 옵셔널 언래핑을 위해 옵셔널 바인딩(if let)
            let decoder = PropertyListDecoder() //property list 디코더 생성
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding item array. \(error)")
            }
        }
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
        
        saveItems() //마크할때도 저장
        
//        tableView.reloadData() //saveItems() 안에 있기 때문에 지워도 됨
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

