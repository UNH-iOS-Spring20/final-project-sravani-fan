//
//  CommentsTableViewController.swift
//  MyReseau
//
//  Created by fan li on 2020/5/7.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    var fireDBID: String?
    var commentList = Array<CommentsInfo>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(FireCommentsCell.self, forCellReuseIdentifier: "FireCommentsCell")
        self.title = "Comments"
        requestComments()
        self.tableView.reloadData()
    }

    func requestComments() {
        HUD.flash(.progress,delay: 60)
        ReseauDB.collection(fireCollectionMessageKey).document(self.fireDBID ?? "-").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let model = dataDescription?.kj.model(MassageInfo.self)
                guard let list = model?.commentList else {return}
                self.commentList = list
                self.tableView.reloadData()
                HUD.hide()
            } else {
                HUD.flash(.label("Document does not exist"),delay: 1)
                print("Document does not exist")
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FireCommentsCell", for: indexPath) as! FireCommentsCell
        let model = commentList[indexPath.row]
        cell.updateCell(image: model.userInfo?.imgUrl, nick: model.userInfo?.nickName, content: model.content)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let content = commentList[indexPath.row].content else {
            return 80
        }
        let str = content as NSString
        let font = UIFont.systemFont(ofSize: 15)
        let rect = str.boundingRect(with: CGSize.init(width: screenWidth - 81 - 16, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let height = rect.size.height + 52
        if height < 80 {
            return 80
        }
        return height
    }
}


class FireCommentsCell : UITableViewCell {
    
    lazy var avatar: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 30
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var nickname: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex(hexString: "333333")
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var content: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex(hexString: "666666")
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "FireCommentsCell")
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.backgroundColor = .white
        
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(10)
            make.width.height.equalTo(60)
        }
        
        contentView.addSubview(nickname)
        nickname.snp.makeConstraints { (make) in
            make.left.equalTo(81)
            make.top.equalTo(avatar.snp_top)
            make.right.equalTo(-16)
        }
        
        contentView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.left.equalTo(81)
            make.right.equalTo(-16)
            make.top.equalTo(40)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.hex(hexString: "f1f1f1")
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.left.equalTo(81)
            make.right.equalTo(-16)
            make.height.equalTo(1)
        }
    }
    
    func updateCell(image url: String?, nick name: String?, content ctn: String?){
        avatar.kf.setImage(urlString: url, placeholder: UIImage.init(named: "default_head"))
        nickname.text = name
        content.text = ctn
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
