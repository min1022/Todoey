//
//  CategoryViewController.swift
//  Todoey
//
//  Created by GlobalHumanism on 2019. 1. 2..
//  Copyright © 2019년 GlobalHumanism. All rights reserved.
//

import UIKit
//import CoreData
import SnapKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    //MARK: Initialize a new realm
    let realm = try! Realm()
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //crud하기 위한 콘텍스트
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.register(CategoryCell.self, forCellReuseIdentifier: cellId)
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        navigationItem.title = "Todoey"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        naviTabAdd()
        loadCategories()
    }
    
    //MARK: Add new Categories
    func naviTabAdd() {
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(addButtonPressed(_:)))
        
        navigationItem.setRightBarButtonItems([addBtn], animated: true)
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//            let newCategory = Category(context: self.context) //콘텍스트 구체화
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in //클로져 생성, field는 텍스트필드 이름
            textField = field
            textField.placeholder = "Add a new category"
        } //얼러트 팝업에 텍스트뷰 삽입
        
        present(alert, animated: true,  completion: nil)
    }
    
    //MARK - Model Manipulation Methods (카테고리 저장)
    func save(category: Category) { //Create
        do {
//            try context.save()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
//        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("error loading categories \(error)")
//        }
//        tableView.reloadData()
    }
    
    //Mark - tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "goToItems", sender: self)
    self.navigationController?.pushViewController(TodoListViewController(), animated: true) //segue 대신 사용
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //셀 행 선택
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row] //TodoList뷰컨트롤러에 selectdCategory 프로퍼티 설정해주어야함
        }
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

