//
//  ViewController.swift
//  Todoey
//
//  Created by GlobalHumanism on 2018. 12. 12..
//  Copyright © 2018년 GlobalHumanism. All rights reserved.
//


import UIKit
import RealmSwift
import SnapKit


class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<ItemRealm>?
    
    lazy var searchBar : UISearchBar = UISearchBar()
    
    let realm = try! Realm()
    
    var selectedCategory : CategoryRealm? {//destinationVC.selectedCategory = categories[indexPath.row] 코드 전까지는 nil일 것이기 때문에 옵셔널 선언
        didSet {
            loadItems() //viewdidload에 있던거 옮김
            //predicate: NSPredicate? = nil로 디폴트갑 설정해서 파라미터없이 그냥쓸 수 있음
            
        }//selectedCategory가 값을 갖자마자 실행
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        navigationItem.title = "Items"
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.backgroundColor = UIColor.yellow
        tableView.register(TodoCell.self, forCellReuseIdentifier: cellId)
//        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = .white
//        tableView.frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: 500)
 
        searchBar.delegate = self as? UISearchBarDelegate
        searchBarLayout()
        naviTabAdd()
    }
    
    //MARK: SearchBar Layout
    func searchBarLayout() {
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
     
        searchBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    //MARK: Add new items
    func naviTabAdd() {
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(cellAdd(_:)))
        
        navigationItem.setRightBarButtonItems([addBtn], animated: true)
    }
    
    @objc func cellAdd(_ sender: UIBarButtonItem) {
        
        print("렘0 \(self.selectedCategory)")
        
        var textField = UITextField() //alert.add ...에 접근 가능
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
           //newItem.parentCategory = self.selectedCategory//Category랑 Item 관계설정했으므로 접근가능 -코어데이터 코드 대체-
        if let currentCategory = self.selectedCategory { //nil일 경우 대비해서 옵셔널 바인딩
          
            print("렘1 \(currentCategory)")
            do {
                try self.realm.write {
                    let newItem = ItemRealm()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    //self.itemArray.append(newItem) -코어데이터 코드 대체-
                    
                    print("렘2 \(newItem)")
                    
                    }
                } catch {
                    print("Error saving new items, \(error)")
            }
        }
            self.tableView.reloadData()
//            self.saveItems()
    } //클로져 안에서 사용하므로 self를 써줘야함
        
        alert.addTextField { (alertTextField) in //클로져 생성
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        } //얼러트 팝업에 텍스트뷰 삽입
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
   
    //NSFetchRequest<Item> 리퀘스트 인자 받아서 배열로 리턴
    //with : 외부 인자 (request라는 내부 인자는 현재 블록 안의 코드를 실행, 외부인자는 함수 호출할때 사용)
    func loadItems() { //Read
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        //카테고리의 이름 프로퍼티가 선택된 현재 카테고리의 이름과 반드시 매치되어야함
//        //필터링해서 패런트카테고리와 매치되는 현재 선택된 카테고리의 이름만을 가짐
//
//        //additionalPredicate -> unwrapped
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        //아이템 형식에 결과를 fetch
//        //Item : 리퀘스트하려고 하는 entity
////        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        //패치 리퀘스트 이미 인자로 받아놔서 새 리퀘스트로 이니셜라이징할 필요 없음
//        //따라야할 로직 많으므로 데이터타입 구체화 요구됨
//        //데이터타입 지정 안해주면 "Ambiguous use of..." 에러
//        do {
//            itemArray = try context.fetch(request) //빈 request에 현재 영속성 컨테이너에 있는 모두를 넣음
//        //컨텍스트 fetch 저장 안하면 에러 throw함
//        } catch {
//            print("error fetching data from context \(error)")
//        } //********코어 데이터****************
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                realm.delete(item)
                }
            } catch {
                print("error deleting item, \(error)")
            }
        }
    }
    
    //Mark - tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        //superclass 테이블뷰 셀 불러옴
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //-->Ternary operator<--
            //value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none //밑의 if문과 같은 기능

        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write { //update values
                    item.done = !item.done //toggle property opposite
                }
            } catch {
                    print("error saving done status, \(error)")
            }
        }
        
        tableView.reloadData() //cellforrowat indexpath 호출
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//class TodoCell: UITableViewCell {
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

//MARK: - Search Bar Methods
extension TodoListViewController : UISearchBarDelegate {
//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //DispatchQueue : 다른 쓰레드(메인)로 승인해주는 매니저 역할
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            //디스패쳐에게 메인 키를 요청하고 메인 큐에서 위의 메소드를 실햏함
            //포어그라운드에서 실행됨
            
        }
    }
}
