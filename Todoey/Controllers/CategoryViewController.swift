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
//import SwipeCellKit

class CategoryViewController: SwipeTableViewController { //Swipe컨트롤러가 uitableview, swipetabledelegate 다 가지고 있음
    
    //MARK: Initialize a new realm
    let realm = try! Realm()
    
    //Results -> realm의 자동 업데이트 컨테이너 타입
    var categories: Results<CategoryRealm>? //닐값 감수해서 옵셔널 선언
//    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.register(CategoryCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = 80.0
        navigationItem.title = "Todoey"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        naviTabAdd()
        loadCategories()
    }
    
    
    //MARK: Add new Categories
    func naviTabAdd() {
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
        
        navigationItem.setRightBarButtonItems([addBtn], animated: true)
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//            let newCategory = Category(context: self.context) //콘텍스트 구체화
            let newCategory = CategoryRealm()
            newCategory.name = textField.text!
            
//            self.categories.append(newCategory) realm 컨테이너에서 자동업데이트 되ㅁ로 필요없음
            self.save(category: newCategory)  //realm 컨테이너에 저장
            
//            self.performSegue(withIdentifier: "todoItems", sender: sender.self)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in //클로져 생성, field는 텍스트필드 이름
            textField = field
            textField.placeholder = "Add a new category"
        } //얼러트 팝업에 텍스트뷰 삽입
        
        present(alert, animated: true,  completion: nil)
    }
    
    //MARK - Model Manipulation Methods (카테고리 저장)
    func save(category: CategoryRealm) { //Create
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
        
        //realm안의 item 전부를 꺼내옴
        categories = realm.objects(CategoryRealm.self)
        
        //CoreData 코드
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("error loading categories \(error)")
//        }
        tableView.reloadData()
    }
    
    //MARK - Delete data from Swipe (삭제)
    //슈퍼클래스의 updateModel 함수 재정의
    override func updateModel(at indexPath: IndexPath) {
        
//        super.updateModel(at: indexPath) //Superclass 호출(슈퍼클래스 프린트문력출력)
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category \(error)")
            }
            //tableView.reloadDatsa()
        }
    }
    
    //Mark - tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //nil이면 1 리턴, ??는 nil coalescing operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"

        return cell
    }
    
    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "goToItems", sender: self)
//        self.performSegue(withIdentifier: "todoItems", sender: self)
        self.navigationController?.pushViewController(TodoListViewController(), animated: true) //segue 대신 사용
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToItems", sender: self)
        }
        //셀 행 선택
        if (segue.identifier == "todoItems") {
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] //TodoList뷰컨트롤러에 selectdCategory 프로퍼티 설정해주어야함
            
            print(destinationVC.selectedCategory)
            
            }
        }
    }
}

