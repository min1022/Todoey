//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by GlobalHumanism on 2019. 1. 22..
//  Copyright © 2019년 GlobalHumanism. All rights reserved.
//

/* Superclass */
import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
 
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SwipeTableViewCell
        
        // categories 없음. UI만 담당하는 부분이므로 주석처리
//        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        //삭제 딜리게이트 메소드들이 전부 모여있는 곳이라 킵해둠
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        //checking orientation of swipe (from the right)
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            // closure that handles what should happen when the cell gets swiped
            
            //update the realm
            
            print("Delete cell")
            
            self.updateModel(at: indexPath) //밑에 코드 대체
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        //셀 스와이프 시 보여주는 셀의 한 부분에 이미지 추가
        
        return [deleteAction]
        //삭제 액션 반환
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive //클릭없이 삭제가능한 옵션
        //        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        //Update our dataModel
        
        print("ITEM DELETED FROM SUPERCLASS") //category애소 override해서 출력 안됨
    }
}

class CategoryCell: SwipeTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TodoCell: SwipeTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
