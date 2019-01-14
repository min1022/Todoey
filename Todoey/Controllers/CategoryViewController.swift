//
//  CategoryViewController.swift
//  Todoey
//
//  Created by GlobalHumanism on 2019. 1. 2..
//  Copyright © 2019년 GlobalHumanism. All rights reserved.
//

import UIKit
import CoreData
import SnapKit

class CategoryViewController: UITableViewController {
    
    lazy var searchBar : UISearchBar = UISearchBar()

    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    let cellId = "cellId"
    
    var itemArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        navigationItem.title = "Todoey"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        naviTabAdd()
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
            
            let newItem = Category(context: self.context)
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
    func saveItems() { // Create
        
        do {
            try context.save()
            //변경사항 생길때 컨테이너에 저장
        } catch {
            print("Error saving context \(error)")
            
        }
        self.tableView.reloadData()
    }
    
    //NSFetchRequest<Item> 리퀘스트 인자 받아서 배열로 리턴
    //with : 외부 인자 (request라는 내부 인자는 현재 블록 안의 코드를 실행, 외부인자는 함수 호출할때 사용)
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()/*default value 설정*/) { //Read
        
        //아이템 형식에 결과를 fetch
        //Item : 리퀘스트하려고 하는 entity
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //패치 리퀘스트 이미 인자로 받아놔서 새 리퀘스트로 이니셜라이징할 필요 없음
        //따라야할 로직 많으므로 데이터타입 구체화 요구됨
        //데이터타입 지정 안해주면 "Ambiguous use of..." 에러
        do {
//            itemArray = try context.fetch(request) //빈 request에 현재 영속성 컨테이너에 있는 모두를 넣음
            //컨텍스트 fetch 저장 안하면 에러 throw함
        } catch {
            print("error fetching data from context \(error)")
        }
    }
    
    //Mark - tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

class CategoryCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

