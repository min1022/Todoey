//
//  ViewController.swift
//  Todoey
//
//  Created by GlobalHumanism on 2018. 12. 12..
//  Copyright © 2018년 GlobalHumanism. All rights reserved.
//

/* 코어데이터 CRUD 유의사항
 1. 컨텍스트를 저장 context.save()
 2. 현재 상태를 영속 컨테이너에 commit
 3. 영구 저장소에 있는 데이터 변경 시 context.save()에 저장하지 않기 위해 항상 context 호출
 4. 조회나 loadItems() 실행 시 영속 컨테이너를 변경할 필요가 없으므로 context를 save할 필요없음. 대신 fetch하고 현재 버전 조회
 */

import UIKit
import RealmSwift
import SnapKit


class TodoListViewController: UITableViewController {
    
    var todoItems: Results<ItemRealm>?
    
    lazy var searchBar : UISearchBar = UISearchBar()
    
    let realm = try! Realm()
    
    //영속성 컨테이너의 view context
    //UIApplication class
    //shared: 싱글턴 객체
    //delegate: 옵셔널 uiapplication 딜리게이트 타입
    //둘 다 같은 슈퍼클래스에서 상속받기 때문에 앱딜리게이트 클래스로 캐스팅함
    //앱딜리게이트를 객체로 접근할 수 있음
    //Appdelegate라고 쓰는대신 ()로 표기, 클래스 딜리게이트로 다운캐스팅
    
    let cellId = "cellId"
    
    var selectedCategory : CategoryRealm? {//destinationVC.selectedCategory = categories[indexPath.row] 코드 전까지는 nil일 것이기 때문에 옵셔널 선언
        didSet {
            loadItems() //viewdidload에 있던거 옮김
            //predicate: NSPredicate? = nil로 디폴트갑 설정해서 파라미터없이 그냥쓸 수 있음
            
        }//selectedCategory가 값을 갖자마자 실행
    }
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")//영속 코어 데이터 파일 경로
    
    //fisrt.에서 append 메소드 불러와서 새로운 커스텀 plist 만들기
    //유저 홈디렉토리 (현재 앱에 아이템 저장하는 장소)
    //documents/ 폴더 안에 plist 생성
    //items.plist에 Item 클래스의 프로퍼티를 적용
    
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
        
//        guard let headerView = tableView.tableHeaderView else {
//            return
//        }
//
//        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//
//        if headerView.frame.size.height != size.height {
//            headerView.frame.size.height = size.height
//
//        tableView.tableHeaderView = headerView
//        }
//
        searchBar.delegate = self as? UISearchBarDelegate
        searchBarLayout()
        naviTabAdd()
        
        //영속성 컨테이너의 view.context를 얻어와서 context를 context라고 쓸 수 있게됨.
//        let newItem = Item()
//        newItem.title = "ㄴㅇㄹㅇ"
//        self.itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "find mike"
//        itemArray.append(newItem2)
    
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {//데이터가 nil일시 충돌날 수 도 있으므로 if let으로 옵셔널 바인딩, 아이템의 어레이를 되찾아옴 -> as? [Item]
//            itemArray = items
//        }
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
    
    //MARK - Model Manipulation Methods (아이템 저장)
    /* 코어 데이터하면서 인코더 지움*/
//    func saveItems() { // Create
//
//        do {
//          try context.save()
//            //변경사항 생길때 컨테이너에 저장
//        } catch {
//            print("Error saving context \(error)")
//
//        }
//        self.tableView.reloadData()
//    }
    
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
        
        print("렘")
        
        tableView.reloadData()
    }
    
    //Mark - tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //-->Ternary operator<--
            //value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none //밑의 if문과 같은 기능
            
            //        if item.done == true {
            //            cell.accessoryType = .checkmark
            //        } else {
            //            cell.accessoryType = .none
            //        }
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
        
//        todoItems?[indexPath.row].setValue("Completed", forKey: "title")
        //done표시할때 테이블뷰 타이틀 변경 (Update)

         /* Delete 아이템 배열에서 지우기 전에 먼저 컨텍스트에서 지워야함(순서) */
//        context.delete(itemArray[indexPath.row])//영속 컨테이너로부터의 데이터 삭제
//        itemArray.remove(at: indexPath.row)
        //아이템 배열로부터 현재 아이템 삭제 (테이블뷰 데이터소스 로드)
        
        //컨텍스트로부터 데이터를 지우므로 context를 ManagedObject 형으로 구체화시켜줌
       
        
//        todoItems?[indexPath.row].done = !todoItems[indexPath.row].done//셀 체크
//
//        saveItems() //마크할때도 저장
        
//        tableView.reloadData() //saveItems() 안에 있기 때문에 지워도 됨
       
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

//MARK: - Search Bar Methods
extension TodoListViewController : UISearchBarDelegate {
//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //읽어들이기 위해서 request 생성과 타입 선언
     
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        //predicate은 데어터가 어떻게 fatched나 filtered 구체화되어야 할때 쓰는 기초 클래스
//        //쿼리 언어 (format string)
//        //cd -> case and diacritic insensitive
//        //쿼리를 reuest에 추가
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        //데이터 정렬
//        //복수 형태라서 배열 표기해야함
//
//        loadItems()
        
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
