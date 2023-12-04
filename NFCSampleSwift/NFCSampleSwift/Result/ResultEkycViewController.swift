//
//  ResultEkycViewController.swift
//  FullVNPTeKYC
//
//  Created by Minh Nguyễn Minh on 04/01/2023.
//

import UIKit

class ResultEkycViewController: UIViewController {
    
    // Thông tin mã QR
    var scanQRCodeResult: String = ""
    
    // Thông tin NFC
    var nfcResult: [String : Any] = [String : Any]()
    
    // Thông tin postcode
    var postcodePlaceOfOrigin: [String : Any] = [String : Any]()
    var postcodePlaceOfResidence: [String : Any] = [String : Any]()
    
    // Thông tin verify C06
    var verifyC06Result: [String : Any] = [String : Any]()
    
    // Thông tin ẢNH chân dung
    var imageAvatar: UIImage = UIImage()
    var hashImageAvatar: String = ""
    
    // Thông tin Client Session
    var clientSession: String = ""
    
    @IBOutlet weak var tableViewResult: UITableView!
    
    private var listInformation: [[String : Any]] = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Thông tin mã QR
        if self.scanQRCodeResult != "" {
            self.listInformation.append(["title" : "Scan QR Code", "content" : self.scanQRCodeResult, "image" : UIImage(), "isVideo" : false])
        }
        
        // Thông tin NFC
        if self.nfcResult.count != 0 {
            self.listInformation.append(["title" : "NFC Result", "content" : String(describing: self.nfcResult), "image" : UIImage(), "isVideo" : false])
        }
        
        // Thông tin postcodePlaceOfOrigin
        if self.postcodePlaceOfOrigin.count != 0 {
            self.listInformation.append(["title" : "Postcode Place Of Origin", "content" : String(describing: self.postcodePlaceOfOrigin), "image" : UIImage(), "isVideo" : false])
        }
        
        // Thông tin postcodePlaceOfResidence
        if self.postcodePlaceOfResidence.count != 0 {
            self.listInformation.append(["title" : "Postcode Place Of Residence", "content" : String(describing: self.postcodePlaceOfResidence), "image" : UIImage(), "isVideo" : false])
        }
        
        // Thông tin verifyC06Result
        if self.verifyC06Result.count != 0 {
            self.listInformation.append(["title" : "Verify C06 Result", "content" : String(describing: self.verifyC06Result), "image" : UIImage(), "isVideo" : false])
        }
        
        // Thông tin ẢNH chân dung
        if self.hashImageAvatar != "" || (self.imageAvatar.size.width != 0 && self.imageAvatar.size.height != 0) {
            self.listInformation.append(["title" : "Image Avatar", "content" : self.hashImageAvatar, "image" : self.imageAvatar, "isVideo" : false])
        }
        
        // Thông tin Client Session
        if self.clientSession != "" {
            self.listInformation.append(["title" : "Client Session", "content" : self.clientSession, "image" : UIImage(), "isVideo" : false])
        }
        
        
        self.title = "Hiển thị kết quả"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Đóng", style: .plain, target: self, action: #selector(self.closeViewController))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Copy All", style: .plain, target: self, action: #selector(self.actionCopyAll))
        
        
        // register customize cell (CheckinHistoryCell) is the children tableViewCheckinHistory
        self.tableViewResult.register(UINib(nibName: "ResultEkycCell", bundle: Bundle.main), forCellReuseIdentifier: "ResultEkycCell")
        self.tableViewResult.register(UINib(nibName: "ResultEkycHeader", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "ResultEkycHeader")
        // setup tableView Checkin History
        self.tableViewResult.delegate = self
        self.tableViewResult.dataSource = self
        self.tableViewResult.backgroundColor = UIColor.white
        self.tableViewResult.separatorStyle = .none
        
    }
    
    
    // Called when the view is about to made visible. Default does nothing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Called when the view has been fully transitioned onto the screen. Default does nothing
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // Called just before the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    // Called just after the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    
    @objc private func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func actionCopyAll() {
        // copy text
        var text = ""
        for information in self.listInformation {
            let title: String = information["title"] as? String ?? ""
            let content: String = information["content"] as? String ?? ""
            
            text = text + "\(title) = \(content)\n\n"
        }
        UIPasteboard.general.string = ""
        UIPasteboard.general.string = text
    }
    
    @objc private func actionPlayVideo(sender: UIButton) {
        
    }
    
    
    @objc private func actionCopy(sender: UIButton) {
        let tagView = sender.tag
        
        let item = self.listInformation[tagView]
        // let title: String = item["title"] as? String ?? ""
        let content: String = item["content"] as? String ?? ""
        
        UIPasteboard.general.string = ""
        UIPasteboard.general.string = content
    }
    
}

extension ResultEkycViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listInformation.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ResultEkycHeader") as! ResultEkycHeader
        headerView.backgroundColor = UIColor(red: 24.0/255.0, green: 214.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        headerView.contentView.backgroundColor = UIColor(red: 24.0/255.0, green: 214.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        
        let item = self.listInformation[section]
        let title: String = item["title"] as? String ?? ""
        let isVideo: Bool = item["isVideo"] as? Bool ?? false
        
        headerView.labelTitle.text = title
        headerView.labelTitle.textColor = UIColor(red: 20.0/255.0, green: 39.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        headerView.labelTitle.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        headerView.buttonCopy.setTitleColor(UIColor(red: 20.0/255.0, green: 39.0/255.0, blue: 48.0/255.0, alpha: 1.0), for: .normal)
        headerView.buttonCopy.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        headerView.buttonCopy.tag = section
        if isVideo {
            headerView.buttonCopy.setTitle("Xem video", for: .normal)
            headerView.buttonCopy.addTarget(self, action: #selector(self.actionPlayVideo(sender:)), for: .touchUpInside)
        } else {
            headerView.buttonCopy.setTitle("Sao chép", for: .normal)
            headerView.buttonCopy.addTarget(self, action: #selector(self.actionCopy(sender:)), for: .touchUpInside)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultEkycCell", for: indexPath) as! ResultEkycCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.white
        
        let item = self.listInformation[indexPath.section]
        let content: String = item["content"] as? String ?? ""
        let image: UIImage = item["image"] as? UIImage ?? UIImage()
        let widthImage = image.size.width
        let heightImage = image.size.height
        if widthImage != 0 && heightImage != 0 {
            // hiển thị ảnh
            let widthImageView = UIScreen.main.bounds.size.width - 16.0
            let heightImageView = (widthImageView * heightImage) / widthImage
            cell.imageViewCapture.isHidden = false
            cell.imageViewCapture.image = image
            cell.widthImageView.constant = widthImageView
            cell.heightImageView.constant = heightImageView
        } else {
            // ẩn ảnh
            cell.imageViewCapture.isHidden = true
            cell.widthImageView.constant = 0.0
            cell.heightImageView.constant = 0.0
        }
        cell.labelContent.text = content
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
    }
}
