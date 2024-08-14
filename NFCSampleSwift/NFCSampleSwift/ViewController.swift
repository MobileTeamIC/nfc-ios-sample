//
//  ViewController.swift
//  NFCSampleSwift
//
//  Created by Minh Nguyễn Minh on 16/06/2023.
//

import UIKit
import ICNFCCardReader

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonStart_QR_NFC: UIButton!
    @IBOutlet weak var buttonStart_MRZ_NFC: UIButton!
    @IBOutlet weak var buttonStart_Only_NFC: UIButton!
    @IBOutlet weak var buttonStart_Only_NFC_WithoutUI: UIButton!
    
    // Số giấy tờ căn cước, là dãy số gồm 12 ký tự. (ví dụ 123456789000)
    let idNumber = ""
    // Ngày sinh của người dùng được in trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
    let birthday = ""
    // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
    let expiredDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Thực hiện quét mã QR và đọc thông tin thẻ Căn cước NFC
        self.buttonStart_QR_NFC.setTitle("QR → NFC", for: .normal)
        self.buttonStart_QR_NFC.setTitleColor(UIColor.white, for: .normal)
        self.buttonStart_QR_NFC.layer.cornerRadius = 6
        self.buttonStart_QR_NFC.addTarget(self, action: #selector(self.actionStart_QR_NFC), for: .touchUpInside)
        
        // Thực hiện quét mã MRZ và đọc thông tin thẻ Căn cước NFC
        self.buttonStart_MRZ_NFC.setTitle("MRZ → NFC", for: .normal)
        self.buttonStart_MRZ_NFC.setTitleColor(UIColor.white, for: .normal)
        self.buttonStart_MRZ_NFC.layer.cornerRadius = 6
        self.buttonStart_MRZ_NFC.addTarget(self, action: #selector(self.actionStart_MRZ_NFC), for: .touchUpInside)
        
        // Truyền thông tin và mở SDK để đọc thông tin thẻ Căn cước
        self.buttonStart_Only_NFC.setTitle("Only NFC", for: .normal)
        self.buttonStart_Only_NFC.setTitleColor(UIColor.white, for: .normal)
        self.buttonStart_Only_NFC.layer.cornerRadius = 6
        self.buttonStart_Only_NFC.addTarget(self, action: #selector(self.actionStart_Only_NFC), for: .touchUpInside)
        
        // Truyền thông tin và đọc thông tin thẻ Căn cước không có giao diện SDK
        self.buttonStart_Only_NFC_WithoutUI.setTitle("Only NFC Without UI", for: .normal)
        self.buttonStart_Only_NFC_WithoutUI.setTitleColor(UIColor.white, for: .normal)
        self.buttonStart_Only_NFC_WithoutUI.layer.cornerRadius = 6
        self.buttonStart_Only_NFC_WithoutUI.addTarget(self, action: #selector(self.actionStart_Only_NFC_WithoutUI), for: .touchUpInside)
        
        // Hiển thị LOG khi thực hiện SDK
        ICNFCSaveData.shared().isPrintLogRequest = true
    }
    
    
    // Cài đặt màu sắc
    private func UIColorFromRGB(rgbValue: UInt, alpha: CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    
    // Hiển thị thông báo cho người dùng
    private func showAlertController(titleAlert: String, messageAlert: String, titleAction: String) {
        
        let alertController = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        let actionClose = UIAlertAction(title: titleAction, style: .default) { (action:UIAlertAction) in
        }
        
        alertController.addAction(actionClose)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    // Thực hiện quét mã QR và đọc thông tin thẻ Căn cước NFC
    @objc private func actionStart_QR_NFC() {
        
        // Chức năng đọc thông tin thẻ chip bằng NFC, từ iOS 13.0 trở lên
        if #available(iOS 13.0, *) {
            let objICMainNFCReader = ICMainNFCReaderRouter.createModule() as! ICMainNFCReaderViewController
            
            /*========== CÁC THUỘC TÍNH CHÍNH ==========*/
            
            // Đặt giá trị DELEGATE để nhận kết quả trả về
            objICMainNFCReader.icMainNFCDelegate = self
            
            // Nhập thông tin bộ mã truy cập.
            // Lấy tại mục Quản lý Token https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
            // Bộ token của NFC
            objICMainNFCReader.accessToken = ""
            objICMainNFCReader.tokenId = ""
            objICMainNFCReader.tokenKey = ""
            
            // Bộ token của eKYC (dùng để upload ảnh)
            objICMainNFCReader.accessTokenEKYC = ""
            objICMainNFCReader.tokenIdEKYC = ""
            objICMainNFCReader.tokenKeyEKYC = ""
            
            // Giá trị này xác định ngôn ngữ được sử dụng trong SDK.
            // - icnfc_vi: Tiếng Việt
            // - icnfc_en: Tiếng Anh
            objICMainNFCReader.languageSdk = "icekyc_vi"
            
            // Giá trị này xác định việc có hiển thị màn hình trợ giúp hay không.
            objICMainNFCReader.isShowTutorial = true
            
            // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video. Mặc định false (Không hiện)
            // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn".
            objICMainNFCReader.isEnableGotIt = true
            
            // Thuộc tính quy định việc đọc thông tin NFC
            // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
            // - MRZCode: Quét mã MRZ sau đó đọc thông tin thẻ Chip NFC
            // - NFCReader: Nhập thông tin cho Số thẻ, ngày sinh và ngày hết hạn
            // => sau đó đọc thông tin thẻ Chip NFC
            objICMainNFCReader.cardReaderStep = QRCode
            // Trường hợp cardReaderStep là NFCReader thì mới cần truyền 03 thông tin idNumberCard, birthdayCard, expiredDateCard
            // Số giấy tờ căn cước, là dãy số gồm 12 ký tự.
            // objICMainNFCReader.idNumberCard = self.idNumber
            // Ngày sinh trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
            // objICMainNFCReader.birthdayCard = self.birthday
            // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
            // objICMainNFCReader.expiredDateCard = self.expiredDate
            
            // bật chức năng tải ảnh chân dung trong CCCD để lấy mã ảnh tại ICNFCSaveData.shared().hashImageAvatar
            objICMainNFCReader.isEnableUploadAvatarImage = true
            
            // Bật tính năng Matching Postcode, để lấy thông tin mã khu vực
            // Thông tin mã Quê quán tại ICNFCSaveData.shared().postcodePlaceOfOriginResult
            // Thông tin mã Nơi thường trú tại ICNFCSaveData.shared().postcodePlaceOfResidenceResult
            objICMainNFCReader.isGetPostcodeMatching = false

            
            // Giá trị này được truyền vào để xác định nhiều luồng giao dịch trong một phiên. Mặc định ""
            // Ví dụ sau khi Khách hàng thực hiện eKYC => sẽ sinh ra 01 ClientSession
            // Khách hàng sẽ truyền ClientSession vào giá trị này => khi đó eKYC và NFC sẽ có chung ClientSession
            // => tra xuất dữ liệu sẽ dễ hơn trong quá trình đối soát
            objICMainNFCReader.inputClientSession = ""
            
            // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
            // Trường hợp KHÔNG truyền readingTagsNFC => sẽ thực hiện đọc hết tất cả
            // Trường hợp CÓ truyền giá trị cho readingTagsNFC => sẽ đọc các thông tin truyền vào và mã DG13
            // VerifyDocumentInfo - Thông tin bảo mật thẻ
            // MRZInfo - Thông tin mã MRZ
            // ImageAvatarInfo - Thông tin ảnh chân dung trong thẻ
            // SecurityDataInfo - Thông tin bảo vệ thẻ
            let tagsNFC = [CardReaderValues.VerifyDocumentInfo.rawValue, CardReaderValues.MRZInfo.rawValue, CardReaderValues.ImageAvatarInfo.rawValue, CardReaderValues.SecurityDataInfo.rawValue]
            objICMainNFCReader.readingTagsNFC = tagsNFC
            
            // bật tính năng xác định thẻ có bị giả mạo hoặc sao chép hoặc ghi đè thông tin hay không. Mặc định false
            // Giá trị xác thực Active Authentication tại ICNFCSaveData.shared().statusActiveAuthentication
            // Giá trị xác thực Chip Authentication tại ICNFCSaveData.shared().statusChipAuthentication
            objICMainNFCReader.isEnableCheckChipClone = true
            
            
            /*========== CÁC THUỘC TÍNH VỀ MÔI TRƯỜNG PHÁT TRIỂN - URL TÁC VỤ TRONG SDK ==========*/
            
            // Giá trị tên miền chính của SDK. Mặc định ""
            // objICMainNFCReader.baseDomain = ""
            
            // Đường dẫn đầy đủ thực hiện tải ảnh chân dung lên phía máy chủ để nhận mã ảnh. Mặc định ""
            // objICMainNFCReader.urlUploadImageFormData = ""
            
            // Đường dẫn đầy đủ thực hiện tải thông tin dữ liệu đọc được lên máy chủ. Mặc định ""
            // objICMainNFCReader.urlUploadDataNFC = ""
            
            // Đường dẫn đầy đủ thực hiện kiểm tra mã bưu chính của thông tin giấy tờ như Quê quán, Nơi thường trú. Mặc định ""
            // objICMainNFCReader.urlMatchingPostcode = ""
            
            // Thông tin [KEY: VALUE] truyền vào Header. Mặc định []
            // objICMainNFCReader.headersRequest = ["ABC": "XYZ"]
            
            
            /*========== CÁC THUỘC TÍNH VỀ CÀI ĐẶT MÀU SẮC GIAO DIỆN TRONG SDK ==========*/
            
            // 1. Thanh header: PA 1 nút đóng bên trái (LeftButton). PA 2 nút đóng bên phải (RightButton). mặc định là PA 1 (LeftButton)
            // objICMainNFCReader.modeButtonHeaderBar = LeftButton
            
            // 2. Màu nội dung thanh header (Màu chữ và màu nút đóng). mặc định là FFFFFF
            // objICMainNFCReader.contentColorHeaderBar = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 3. màu nền Thanh header. mặc định là trong suốt
            // objICMainNFCReader.backgroundColorHeaderBar = UIColor.clear
            
            // 4. Màu văn bản chính, Tiêu đề & Văn bản phụ (màu text ở màn Hướng dẫn, ở các màn Quét MRZ, QR, NFC). mặc định là FFFFFF
            // objICMainNFCReader.textColorContentMain = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 5. Màu nền (bao gồm màu nền Hướng dẫn, màu nền lúc quét NFC). mặc định 122F41
            // objICMainNFCReader.backgroundColorMainScreen = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            // 6. Đường line trên hướng dẫn chụp GTTT, bao gồm cả các popup cảnh báo. mặc định E8E8E8
            // objICMainNFCReader.backgroundColorLine = self.UIColorFromRGB(rgbValue: 0xD9D9D9, alpha: 1.0)
            
            // 7. Màu nút bấm (bao gồm nút Tôi đã hiểu, Hướng dẫn, Quét lại (riêng iOS)). mặc định là FFFFFF
            // objICMainNFCReader.backgroundColorButton = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 8. Màu text của nút bấm (bao gồm nút Tôi đã hiểu, Quét lại (riêng iOS)). mặc định 142730
            // objICMainNFCReader.textColorTitleButton = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            // 9. Màu nền chụp (màu nền quét QR, MRZ). mặc định 142730
            // objICMainNFCReader.backgroundColorCapture = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            // 10. Màu hiệu ứng Bình thường (màu animation QR, ĐỌc thẻ chip NFC, màu thanh chạy ở màn NFC, màu nút Hướng dẫn). mặc định 18D696
            // objICMainNFCReader.effectColorAnimation = self.UIColorFromRGB(rgbValue: 0x18D696, alpha: 1.0)
            
            // 11. Màu hiệu ứng thất bại (khi xảy ra lỗi Quét NFC)
            // objICMainNFCReader.effectColorAnimationFailed = self.UIColorFromRGB(rgbValue: 0xCA2A2A, alpha: 1.0)
            
            // 12. Màu nền cho popup. Mặc định FFFFFF
            // objICMainNFCReader.backgroundColorPopup = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 13. Màu văn bản trên popup. Mặc định 142730
            // objICMainNFCReader.textColorContentPopup = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            /*========== CÁC THUỘC TÍNH VỀ TRADEMARK ==========*/
            
            // Hiển thị ảnh thương hiệu ở góc dưới màn hình. Mặc định false
            // objICMainNFCReader.isShowTrademark = true
            
            // Ảnh thương hiệu hiển thị cuối màn hình.
            // objICMainNFCReader.imageTrademark = UIImage()
            
            // Kích thước Logo (phần này cần bổ sung giới hạn chiều rộng và chiều cao). Kích thước logo mặc định NAx24
            // objICMainNFCReader.sizeImageTrademark = CGSize(width: 100.0, height: 24.0)
            
            /*========== CHỈNH SỬA TÊN CÁC TỆP TIN HIỆU ỨNG - VIDEO HƯỚNG DẪN ==========*/
            
            // text hiển thị khi đang đợi đặt thẻ
            // objICMainNFCReader.textReadyNFC = "Bạn vui lòng chạm CCCD vào vùng đọc NFC của thiết bị như hướng dẫn"
            
            // text hiển thị khi xác định được thẻ*/
            // objICMainNFCReader.textDetectedNFC = "Xác thực bằng CCCD gắn chíp....."
            
            // text hiển thị khi đang đọc thẻ*/
            // objICMainNFCReader.textScanningNFC = "Đang thực hiện đọc dữ liệu CCCD\nGiữ nguyên thẻ CCCD với thiết bị"
            
            // text hiện khi đọc thẻ thành công*/
            // objICMainNFCReader.textFinishNFC = "Đọc thông tin thẻ CCCD thành công"
            
            // Tên VIDEO hướng dẫn quét NFC. Mặc định "" (sử dụng VIDEO mặc định khi truyền giá trị rỗng hoặc không truyền)
            // objICMainNFCReader.nameVideoHelpNFC = ""
            
            objICMainNFCReader.modalPresentationStyle = .fullScreen
            objICMainNFCReader.modalTransitionStyle = .coverVertical
            self.present(objICMainNFCReader, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Thực hiện quét mã MRZ và đọc thông tin thẻ Căn cước NFC
    @objc private func actionStart_MRZ_NFC() {
        
        // Chức năng đọc thông tin thẻ chip bằng NFC, từ iOS 13.0 trở lên
        if #available(iOS 13.0, *) {
            let objICMainNFCReader = ICMainNFCReaderRouter.createModule() as! ICMainNFCReaderViewController
            
            /*========== CÁC THUỘC TÍNH CHÍNH ==========*/
            
            // Đặt giá trị DELEGATE để nhận kết quả trả về
            objICMainNFCReader.icMainNFCDelegate = self
            
            // Nhập thông tin bộ mã truy cập.
            // Lấy tại mục Quản lý Token https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
            // Bộ token của NFC
            objICMainNFCReader.accessToken = ""
            objICMainNFCReader.tokenId = ""
            objICMainNFCReader.tokenKey = ""
            
            // Bộ token của eKYC (dùng để upload ảnh)
            objICMainNFCReader.accessTokenEKYC = ""
            objICMainNFCReader.tokenIdEKYC = ""
            objICMainNFCReader.tokenKeyEKYC = ""
            
            // Giá trị này xác định ngôn ngữ được sử dụng trong SDK.
            // - icnfc_vi: Tiếng Việt
            // - icnfc_en: Tiếng Anh
            objICMainNFCReader.languageSdk = "icekyc_vi"
            
            // Giá trị này xác định việc có hiển thị màn hình trợ giúp hay không.
            objICMainNFCReader.isShowTutorial = true
            
            // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video. Mặc định false (Không hiện)
            // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn".
            objICMainNFCReader.isEnableGotIt = true
            
            // Thuộc tính quy định việc đọc thông tin NFC
            // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
            // - MRZCode: Quét mã MRZ sau đó đọc thông tin thẻ Chip NFC
            // - NFCReader: Nhập thông tin cho Số thẻ, ngày sinh và ngày hết hạn
            // => sau đó đọc thông tin thẻ Chip NFC
            objICMainNFCReader.cardReaderStep = MRZCode
            // Trường hợp cardReaderStep là NFCReader thì mới cần truyền 03 thông tin idNumberCard, birthdayCard, expiredDateCard
            // Số giấy tờ căn cước, là dãy số gồm 12 ký tự.
            // objICMainNFCReader.idNumberCard = self.idNumber
            // Ngày sinh trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
            // objICMainNFCReader.birthdayCard = self.birthday
            // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
            // objICMainNFCReader.expiredDateCard = self.expiredDate
            
            // bật chức năng tải ảnh chân dung trong CCCD để lấy mã ảnh tại ICNFCSaveData.shared().hashImageAvatar
            objICMainNFCReader.isEnableUploadAvatarImage = true
            
            // Bật tính năng Matching Postcode, để lấy thông tin mã khu vực
            // Thông tin mã Quê quán tại ICNFCSaveData.shared().postcodePlaceOfOriginResult
            // Thông tin mã Nơi thường trú tại ICNFCSaveData.shared().postcodePlaceOfResidenceResult
            objICMainNFCReader.isGetPostcodeMatching = false
            
            // Giá trị này được truyền vào để xác định nhiều luồng giao dịch trong một phiên. Mặc định ""
            // Ví dụ sau khi Khách hàng thực hiện eKYC => sẽ sinh ra 01 ClientSession
            // Khách hàng sẽ truyền ClientSession vào giá trị này => khi đó eKYC và NFC sẽ có chung ClientSession
            // => tra xuất dữ liệu sẽ dễ hơn trong quá trình đối soát
            objICMainNFCReader.inputClientSession = ""
            
            // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
            // Trường hợp KHÔNG truyền readingTagsNFC => sẽ thực hiện đọc hết tất cả
            // Trường hợp CÓ truyền giá trị cho readingTagsNFC => sẽ đọc các thông tin truyền vào và mã DG13
            // VerifyDocumentInfo - Thông tin bảo mật thẻ
            // MRZInfo - Thông tin mã MRZ
            // ImageAvatarInfo - Thông tin ảnh chân dung trong thẻ
            // SecurityDataInfo - Thông tin bảo vệ thẻ
            let tagsNFC = [CardReaderValues.VerifyDocumentInfo.rawValue, CardReaderValues.MRZInfo.rawValue, CardReaderValues.ImageAvatarInfo.rawValue, CardReaderValues.SecurityDataInfo.rawValue]
            objICMainNFCReader.readingTagsNFC = tagsNFC
            
            // bật tính năng xác định thẻ có bị giả mạo hoặc sao chép hoặc ghi đè thông tin hay không. Mặc định false
            // Giá trị xác thực Active Authentication tại ICNFCSaveData.shared().statusActiveAuthentication
            // Giá trị xác thực Chip Authentication tại ICNFCSaveData.shared().statusChipAuthentication
            objICMainNFCReader.isEnableCheckChipClone = true
            
            
            
            /*========== CÁC THUỘC TÍNH VỀ MÔI TRƯỜNG PHÁT TRIỂN - URL TÁC VỤ TRONG SDK ==========*/
            
            // Giá trị tên miền chính của SDK. Mặc định ""
            // objICMainNFCReader.baseDomain = ""
            
            // Đường dẫn đầy đủ thực hiện tải ảnh chân dung lên phía máy chủ để nhận mã ảnh. Mặc định ""
            // objICMainNFCReader.urlUploadImageFormData = ""
            
            // Đường dẫn đầy đủ thực hiện tải thông tin dữ liệu đọc được lên máy chủ. Mặc định ""
            // objICMainNFCReader.urlUploadDataNFC = ""
            
            // Đường dẫn đầy đủ thực hiện kiểm tra mã bưu chính của thông tin giấy tờ như Quê quán, Nơi thường trú. Mặc định ""
            // objICMainNFCReader.urlMatchingPostcode = ""
            
            // Thông tin [KEY: VALUE] truyền vào Header. Mặc định []
            // objICMainNFCReader.headersRequest = ["ABC": "XYZ"]
            
            
            /*========== CÁC THUỘC TÍNH VỀ CÀI ĐẶT MÀU SẮC GIAO DIỆN TRONG SDK ==========*/
            
            // 1. Thanh header: PA 1 nút đóng bên trái (LeftButton). PA 2 nút đóng bên phải (RightButton). mặc định là PA 1 (LeftButton)
            // objICMainNFCReader.modeButtonHeaderBar = LeftButton
            
            // 2. Màu nội dung thanh header (Màu chữ và màu nút đóng). mặc định là FFFFFF
            // objICMainNFCReader.contentColorHeaderBar = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 3. màu nền Thanh header. mặc định là trong suốt
            // objICMainNFCReader.backgroundColorHeaderBar = UIColor.clear
            
            // 4. Màu văn bản chính, Tiêu đề & Văn bản phụ (màu text ở màn Hướng dẫn, ở các màn Quét MRZ, QR, NFC). mặc định là FFFFFF
            // objICMainNFCReader.textColorContentMain = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 5. Màu nền (bao gồm màu nền Hướng dẫn, màu nền lúc quét NFC). mặc định 122F41
            // objICMainNFCReader.backgroundColorMainScreen = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            // 6. Đường line trên hướng dẫn chụp GTTT, bao gồm cả các popup cảnh báo. mặc định E8E8E8
            // objICMainNFCReader.backgroundColorLine = self.UIColorFromRGB(rgbValue: 0xD9D9D9, alpha: 1.0)
            
            // 7. Màu nút bấm (bao gồm nút Tôi đã hiểu, Hướng dẫn, Quét lại (riêng iOS)). mặc định là FFFFFF
            // objICMainNFCReader.backgroundColorButton = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 8. Màu text của nút bấm (bao gồm nút Tôi đã hiểu, Quét lại (riêng iOS)). mặc định 142730
            // objICMainNFCReader.textColorTitleButton = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            // 9. Màu nền chụp (màu nền quét QR, MRZ). mặc định 142730
            // objICMainNFCReader.backgroundColorCapture = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            // 10. Màu hiệu ứng Bình thường (màu animation QR, ĐỌc thẻ chip NFC, màu thanh chạy ở màn NFC, màu nút Hướng dẫn). mặc định 18D696
            // objICMainNFCReader.effectColorAnimation = self.UIColorFromRGB(rgbValue: 0x18D696, alpha: 1.0)
            
            // 11. Màu hiệu ứng thất bại (khi xảy ra lỗi Quét NFC)
            // objICMainNFCReader.effectColorAnimationFailed = self.UIColorFromRGB(rgbValue: 0xCA2A2A, alpha: 1.0)
            
            // 12. Màu nền cho popup. Mặc định FFFFFF
            // objICMainNFCReader.backgroundColorPopup = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 13. Màu văn bản trên popup. Mặc định 142730
            // objICMainNFCReader.textColorContentPopup = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            /*========== CÁC THUỘC TÍNH VỀ TRADEMARK ==========*/
            
            // Hiển thị ảnh thương hiệu ở góc dưới màn hình. Mặc định false
            // objICMainNFCReader.isShowTrademark = true
            
            // Ảnh thương hiệu hiển thị cuối màn hình.
            // objICMainNFCReader.imageTrademark = UIImage()
            
            // Kích thước Logo (phần này cần bổ sung giới hạn chiều rộng và chiều cao). Kích thước logo mặc định NAx24
            // objICMainNFCReader.sizeImageTrademark = CGSize(width: 100.0, height: 24.0)
            
            /*========== CHỈNH SỬA TÊN CÁC TỆP TIN HIỆU ỨNG - VIDEO HƯỚNG DẪN ==========*/
            
            // text hiển thị khi đang đợi đặt thẻ
            // objICMainNFCReader.textReadyNFC = "Bạn vui lòng chạm CCCD vào vùng đọc NFC của thiết bị như hướng dẫn"
            
            // text hiển thị khi xác định được thẻ*/
            // objICMainNFCReader.textDetectedNFC = "Xác thực bằng CCCD gắn chíp....."
            
            // text hiển thị khi đang đọc thẻ*/
            // objICMainNFCReader.textScanningNFC = "Đang thực hiện đọc dữ liệu CCCD\nGiữ nguyên thẻ CCCD với thiết bị"
            
            // text hiện khi đọc thẻ thành công*/
            // objICMainNFCReader.textFinishNFC = "Đọc thông tin thẻ CCCD thành công"
            
            // Tên VIDEO hướng dẫn quét NFC. Mặc định "" (sử dụng VIDEO mặc định khi truyền giá trị rỗng hoặc không truyền)
            // objICMainNFCReader.nameVideoHelpNFC = ""
            
            objICMainNFCReader.modalPresentationStyle = .fullScreen
            objICMainNFCReader.modalTransitionStyle = .coverVertical
            self.present(objICMainNFCReader, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Truyền thông tin và mở SDK để đọc thông tin thẻ Căn cước
    @objc private func actionStart_Only_NFC() {
        
        if self.idNumber == "" || self.idNumber.count != 12 || self.birthday == "" || self.birthday.count != 6 || self.expiredDate == "" || self.expiredDate.count != 6 {
            self.showAlertController(titleAlert: "Thông báo", messageAlert: "Bạn cần nhập thông tin Số thẻ (12 số), ngày sinh hoặc ngày hết hạn", titleAction: "Đồng ý")
            return
        }
        
        // Chức năng đọc thông tin thẻ chip bằng NFC, từ iOS 13.0 trở lên
        if #available(iOS 13.0, *) {
            let objICMainNFCReader = ICMainNFCReaderRouter.createModule() as! ICMainNFCReaderViewController
            
            /*========== CÁC THUỘC TÍNH CHÍNH ==========*/
            
            // Đặt giá trị DELEGATE để nhận kết quả trả về
            objICMainNFCReader.icMainNFCDelegate = self
            
            // Giá trị này xác định ngôn ngữ được sử dụng trong SDK.
            // - icnfc_vi: Tiếng Việt
            // - icnfc_en: Tiếng Anh
            objICMainNFCReader.languageSdk = "icekyc_vi"
            
            // Giá trị này xác định việc có hiển thị màn hình trợ giúp hay không.
            objICMainNFCReader.isShowTutorial = true
            
            // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video. Mặc định false (Không hiện)
            // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn".
            objICMainNFCReader.isEnableGotIt = true
            
            // Nhập thông tin bộ mã truy cập.
            // Lấy tại mục Quản lý Token https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
            // Bộ token của NFC
            objICMainNFCReader.accessToken = ""
            objICMainNFCReader.tokenId = ""
            objICMainNFCReader.tokenKey = ""
            
            // Bộ token của eKYC (dùng để upload ảnh)
            objICMainNFCReader.accessTokenEKYC = ""
            objICMainNFCReader.tokenIdEKYC = ""
            objICMainNFCReader.tokenKeyEKYC = ""
            
            // Thuộc tính quy định việc đọc thông tin NFC
            // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
            // - MRZCode: Quét mã MRZ sau đó đọc thông tin thẻ Chip NFC
            // - NFCReader: Nhập thông tin cho Số thẻ, ngày sinh và ngày hết hạn
            // => sau đó đọc thông tin thẻ Chip NFC
            objICMainNFCReader.cardReaderStep = NFCReader
            // Trường hợp cardReaderStep là NFCReader thì mới cần truyền 03 thông tin idNumberCard, birthdayCard, expiredDateCard
            // Số giấy tờ căn cước, là dãy số gồm 12 ký tự.
            objICMainNFCReader.idNumberCard = self.idNumber
            // Ngày sinh trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
            objICMainNFCReader.birthdayCard = self.birthday
            // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
            objICMainNFCReader.expiredDateCard = self.expiredDate
            
            // bật chức năng tải ảnh chân dung trong CCCD để lấy mã ảnh tại ICNFCSaveData.shared().hashImageAvatar
            objICMainNFCReader.isEnableUploadAvatarImage = true
            
            // Bật tính năng Matching Postcode, để lấy thông tin mã khu vực
            // Thông tin mã Quê quán tại ICNFCSaveData.shared().postcodePlaceOfOriginResult
            // Thông tin mã Nơi thường trú tại ICNFCSaveData.shared().postcodePlaceOfResidenceResult
            objICMainNFCReader.isGetPostcodeMatching = false
            
            // Giá trị này được truyền vào để xác định nhiều luồng giao dịch trong một phiên. Mặc định ""
            // Ví dụ sau khi Khách hàng thực hiện eKYC => sẽ sinh ra 01 ClientSession
            // Khách hàng sẽ truyền ClientSession vào giá trị này => khi đó eKYC và NFC sẽ có chung ClientSession
            // => tra xuất dữ liệu sẽ dễ hơn trong quá trình đối soát
            objICMainNFCReader.inputClientSession = ""
            
            // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
            // Trường hợp KHÔNG truyền readingTagsNFC => sẽ thực hiện đọc hết tất cả
            // Trường hợp CÓ truyền giá trị cho readingTagsNFC => sẽ đọc các thông tin truyền vào và mã DG13
            // VerifyDocumentInfo - Thông tin bảo mật thẻ
            // MRZInfo - Thông tin mã MRZ
            // ImageAvatarInfo - Thông tin ảnh chân dung trong thẻ
            // SecurityDataInfo - Thông tin bảo vệ thẻ
            let tagsNFC = [CardReaderValues.VerifyDocumentInfo.rawValue, CardReaderValues.MRZInfo.rawValue, CardReaderValues.ImageAvatarInfo.rawValue, CardReaderValues.SecurityDataInfo.rawValue]
            objICMainNFCReader.readingTagsNFC = tagsNFC
            
            // bật tính năng xác định thẻ có bị giả mạo hoặc sao chép hoặc ghi đè thông tin hay không. Mặc định false
            // Giá trị xác thực Active Authentication tại ICNFCSaveData.shared().statusActiveAuthentication
            // Giá trị xác thực Chip Authentication tại ICNFCSaveData.shared().statusChipAuthentication
            objICMainNFCReader.isEnableCheckChipClone = true
            
            
            
            /*========== CÁC THUỘC TÍNH VỀ MÔI TRƯỜNG PHÁT TRIỂN - URL TÁC VỤ TRONG SDK ==========*/
            
            // Giá trị tên miền chính của SDK. Mặc định ""
            // objICMainNFCReader.baseDomain = ""
            
            // Đường dẫn đầy đủ thực hiện tải ảnh chân dung lên phía máy chủ để nhận mã ảnh. Mặc định ""
            // objICMainNFCReader.urlUploadImageFormData = ""
            
            // Đường dẫn đầy đủ thực hiện tải thông tin dữ liệu đọc được lên máy chủ. Mặc định ""
            // objICMainNFCReader.urlUploadDataNFC = ""
            
            // Đường dẫn đầy đủ thực hiện kiểm tra mã bưu chính của thông tin giấy tờ như Quê quán, Nơi thường trú. Mặc định ""
            // objICMainNFCReader.urlMatchingPostcode = ""
            
            // Thông tin [KEY: VALUE] truyền vào Header. Mặc định []
            // objICMainNFCReader.headersRequest = ["ABC": "XYZ"]
            
            
            /*========== CÁC THUỘC TÍNH VỀ CÀI ĐẶT MÀU SẮC GIAO DIỆN TRONG SDK ==========*/
            
            // 1. Thanh header: PA 1 nút đóng bên trái (LeftButton). PA 2 nút đóng bên phải (RightButton). mặc định là PA 1 (LeftButton)
            // objICMainNFCReader.modeButtonHeaderBar = LeftButton
            
            // 2. Màu nội dung thanh header (Màu chữ và màu nút đóng). mặc định là FFFFFF
            // objICMainNFCReader.contentColorHeaderBar = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 3. màu nền Thanh header. mặc định là trong suốt
            // objICMainNFCReader.backgroundColorHeaderBar = UIColor.clear
            
            // 4. Màu văn bản chính, Tiêu đề & Văn bản phụ (màu text ở màn Hướng dẫn, ở các màn Quét MRZ, QR, NFC). mặc định là FFFFFF
            // objICMainNFCReader.textColorContentMain = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 5. Màu nền (bao gồm màu nền Hướng dẫn, màu nền lúc quét NFC). mặc định 122F41
            // objICMainNFCReader.backgroundColorMainScreen = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            // 6. Đường line trên hướng dẫn chụp GTTT, bao gồm cả các popup cảnh báo. mặc định E8E8E8
            // objICMainNFCReader.backgroundColorLine = self.UIColorFromRGB(rgbValue: 0xD9D9D9, alpha: 1.0)
            
            // 7. Màu nút bấm (bao gồm nút Tôi đã hiểu, Hướng dẫn, Quét lại (riêng iOS)). mặc định là FFFFFF
            // objICMainNFCReader.backgroundColorButton = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 8. Màu text của nút bấm (bao gồm nút Tôi đã hiểu, Quét lại (riêng iOS)). mặc định 142730
            // objICMainNFCReader.textColorTitleButton = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            // 9. Màu nền chụp (màu nền quét QR, MRZ). mặc định 142730
            // objICMainNFCReader.backgroundColorCapture = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            // 10. Màu hiệu ứng Bình thường (màu animation QR, ĐỌc thẻ chip NFC, màu thanh chạy ở màn NFC, màu nút Hướng dẫn). mặc định 18D696
            // objICMainNFCReader.effectColorAnimation = self.UIColorFromRGB(rgbValue: 0x18D696, alpha: 1.0)
            
            // 11. Màu hiệu ứng thất bại (khi xảy ra lỗi Quét NFC)
            // objICMainNFCReader.effectColorAnimationFailed = self.UIColorFromRGB(rgbValue: 0xCA2A2A, alpha: 1.0)
            
            // 12. Màu nền cho popup. Mặc định FFFFFF
            // objICMainNFCReader.backgroundColorPopup = self.UIColorFromRGB(rgbValue: 0xFFFFFF, alpha: 1.0)
            
            // 13. Màu văn bản trên popup. Mặc định 142730
            // objICMainNFCReader.textColorContentPopup = self.UIColorFromRGB(rgbValue: 0x142730, alpha: 1.0)
            
            /*========== CÁC THUỘC TÍNH VỀ TRADEMARK ==========*/
            
            // Hiển thị ảnh thương hiệu ở góc dưới màn hình. Mặc định false
            // objICMainNFCReader.isShowTrademark = true
            
            // Ảnh thương hiệu hiển thị cuối màn hình.
            // objICMainNFCReader.imageTrademark = UIImage()
            
            // Kích thước Logo (phần này cần bổ sung giới hạn chiều rộng và chiều cao). Kích thước logo mặc định NAx24
            // objICMainNFCReader.sizeImageTrademark = CGSize(width: 100.0, height: 24.0)
            
            /*========== CHỈNH SỬA TÊN CÁC TỆP TIN HIỆU ỨNG - VIDEO HƯỚNG DẪN ==========*/
            
            // text hiển thị khi đang đợi đặt thẻ
            // objICMainNFCReader.textReadyNFC = "Bạn vui lòng chạm CCCD vào vùng đọc NFC của thiết bị như hướng dẫn"
            
            // text hiển thị khi xác định được thẻ*/
            // objICMainNFCReader.textDetectedNFC = "Xác thực bằng CCCD gắn chíp....."
            
            // text hiển thị khi đang đọc thẻ*/
            // objICMainNFCReader.textScanningNFC = "Đang thực hiện đọc dữ liệu CCCD\nGiữ nguyên thẻ CCCD với thiết bị"
            
            // text hiện khi đọc thẻ thành công*/
            // objICMainNFCReader.textFinishNFC = "Đọc thông tin thẻ CCCD thành công"
            
            // Tên VIDEO hướng dẫn quét NFC. Mặc định "" (sử dụng VIDEO mặc định khi truyền giá trị rỗng hoặc không truyền)
            // objICMainNFCReader.nameVideoHelpNFC = ""
            
            
            objICMainNFCReader.modalPresentationStyle = .fullScreen
            objICMainNFCReader.modalTransitionStyle = .coverVertical
            self.present(objICMainNFCReader, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Truyền thông tin và đọc thông tin thẻ Căn cước không có giao diện SDK
    @objc private func actionStart_Only_NFC_WithoutUI() {
        
        if self.idNumber == "" || self.idNumber.count != 12 || self.birthday == "" || self.birthday.count != 6 || self.expiredDate == "" || self.expiredDate.count != 6 {
            self.showAlertController(titleAlert: "Thông báo", messageAlert: "Bạn cần nhập thông tin Số thẻ (12 số), ngày sinh hoặc ngày hết hạn", titleAction: "Đồng ý")
            return
        }
        
        // Chức năng đọc thông tin thẻ chip bằng NFC, từ iOS 13.0 trở lên
        if #available(iOS 13.0, *) {
            let objICMainNFCReader = ICMainNFCReaderRouter.createModule() as! ICMainNFCReaderViewController
            
            /*========== CÁC THUỘC TÍNH CHÍNH ==========*/
            
            // Đặt giá trị DELEGATE để nhận kết quả trả về
            objICMainNFCReader.icMainNFCDelegate = self
            
            // Nhập thông tin bộ mã truy cập.
            // Lấy tại mục Quản lý Token https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
            // Bộ token của NFC
            objICMainNFCReader.accessToken = ""
            objICMainNFCReader.tokenId = ""
            objICMainNFCReader.tokenKey = ""
            
            // Bộ token của eKYC (dùng để upload ảnh)
            objICMainNFCReader.accessTokenEKYC = ""
            objICMainNFCReader.tokenIdEKYC = ""
            objICMainNFCReader.tokenKeyEKYC = ""
            
            // Thuộc tính quy định việc đọc thông tin NFC
            // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
            // - MRZCode: Quét mã MRZ sau đó đọc thông tin thẻ Chip NFC
            // - NFCReader: Nhập thông tin cho Số thẻ, ngày sinh và ngày hết hạn
            // => sau đó đọc thông tin thẻ Chip NFC
            objICMainNFCReader.cardReaderStep = NFCReader
            // Trường hợp cardReaderStep là NFCReader thì mới cần truyền 03 thông tin idNumberCard, birthdayCard, expiredDateCard
            // Số giấy tờ căn cước, là dãy số gồm 12 ký tự.
            objICMainNFCReader.idNumberCard = self.idNumber
            // Ngày sinh trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
            objICMainNFCReader.birthdayCard = self.birthday
            // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
            objICMainNFCReader.expiredDateCard = self.expiredDate
            
            // bật chức năng tải ảnh chân dung trong CCCD để lấy mã ảnh tại ICNFCSaveData.shared().hashImageAvatar
            objICMainNFCReader.isEnableUploadAvatarImage = true
            
            // Bật tính năng Matching Postcode, để lấy thông tin mã khu vực
            // Thông tin mã Quê quán tại ICNFCSaveData.shared().postcodePlaceOfOriginResult
            // Thông tin mã Nơi thường trú tại ICNFCSaveData.shared().postcodePlaceOfResidenceResult
            objICMainNFCReader.isGetPostcodeMatching = false
            
            // Giá trị này được truyền vào để xác định nhiều luồng giao dịch trong một phiên. Mặc định ""
            // Ví dụ sau khi Khách hàng thực hiện eKYC => sẽ sinh ra 01 ClientSession
            // Khách hàng sẽ truyền ClientSession vào giá trị này => khi đó eKYC và NFC sẽ có chung ClientSession
            // => tra xuất dữ liệu sẽ dễ hơn trong quá trình đối soát
            objICMainNFCReader.inputClientSession = ""
            
            // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
            // Trường hợp KHÔNG truyền readingTagsNFC => sẽ thực hiện đọc hết tất cả
            // Trường hợp CÓ truyền giá trị cho readingTagsNFC => sẽ đọc các thông tin truyền vào và mã DG13
            // VerifyDocumentInfo - Thông tin bảo mật thẻ
            // MRZInfo - Thông tin mã MRZ
            // ImageAvatarInfo - Thông tin ảnh chân dung trong thẻ
            // SecurityDataInfo - Thông tin bảo vệ thẻ
            let tagsNFC = [CardReaderValues.VerifyDocumentInfo.rawValue, CardReaderValues.MRZInfo.rawValue, CardReaderValues.ImageAvatarInfo.rawValue, CardReaderValues.SecurityDataInfo.rawValue]
            objICMainNFCReader.readingTagsNFC = tagsNFC
            
            // bật tính năng xác định thẻ có bị giả mạo hoặc sao chép hoặc ghi đè thông tin hay không. Mặc định false
            // Giá trị xác thực Active Authentication tại ICNFCSaveData.shared().statusActiveAuthentication
            // Giá trị xác thực Chip Authentication tại ICNFCSaveData.shared().statusChipAuthentication
            objICMainNFCReader.isEnableCheckChipClone = true
            
            
            
            /*========== CÁC THUỘC TÍNH VỀ MÔI TRƯỜNG PHÁT TRIỂN - URL TÁC VỤ TRONG SDK ==========*/
            
            // Giá trị tên miền chính của SDK. Mặc định ""
            // objICMainNFCReader.baseDomain = ""
            
            // Đường dẫn đầy đủ thực hiện tải ảnh chân dung lên phía máy chủ để nhận mã ảnh. Mặc định ""
            // objICMainNFCReader.urlUploadImageFormData = ""
            
            // Đường dẫn đầy đủ thực hiện tải thông tin dữ liệu đọc được lên máy chủ. Mặc định ""
            // objICMainNFCReader.urlUploadDataNFC = ""
            
            // Đường dẫn đầy đủ thực hiện kiểm tra mã bưu chính của thông tin giấy tờ như Quê quán, Nơi thường trú. Mặc định ""
            // objICMainNFCReader.urlMatchingPostcode = ""
            
            // Thông tin [KEY: VALUE] truyền vào Header. Mặc định []
            // objICMainNFCReader.headersRequest = ["ABC": "XYZ"]
            
            /*========== CHỈNH SỬA TÊN CÁC TỆP TIN HIỆU ỨNG - VIDEO HƯỚNG DẪN ==========*/
            
            // text hiển thị khi đang đợi đặt thẻ
            // objICMainNFCReader.textReadyNFC = "Bạn vui lòng chạm CCCD vào vùng đọc NFC của thiết bị như hướng dẫn"
            
            // text hiển thị khi xác định được thẻ*/
            // objICMainNFCReader.textDetectedNFC = "Xác thực bằng CCCD gắn chíp....."
            
            // text hiển thị khi đang đọc thẻ*/
            // objICMainNFCReader.textScanningNFC = "Đang thực hiện đọc dữ liệu CCCD\nGiữ nguyên thẻ CCCD với thiết bị"
            
            // text hiện khi đọc thẻ thành công*/
            // objICMainNFCReader.textFinishNFC = "Đọc thông tin thẻ CCCD thành công"
            
            // Thực hiện gọi phương thức đọc thông tin thẻ căn cước gắn chip bằng công nghệ NFC
            objICMainNFCReader.startNFCReaderOutSide()
        } else {
            // Fallback on earlier versions
        }
    }
}


extension ViewController: ICMainNFCReaderDelegate {
    
    // Phương thức khi người dùng nhấn xác nhận thoát SDK
    func icNFCMainDismissed(_ lastStep: ICNFCLastStep) {
        print("close with laststep \(lastStep)")
    }
    
    // Phương thức khi popup đọc NFC đã đóng
    func icNFCPopupReaderChipDisappear() {
        print("Popup đọc đã đóng")
    }
    
    // Phương thức trả trạng thái đọc NFC cùng với lỗi (nếu có)
    func icNFCCardReader(_ state: ICNFCReaderState, progress: Int, error: String) {
        print("state = \(state)")
    }
    
    // Phương thức trả về kết quả đọc NFC
    func icNFCCardReaderGetResult() {
        
        // Hiển thị thông tin kết quả QUÉT QR
        print("scanQRCodeResult = \(ICNFCSaveData.shared().scanQRCodeResult)")
        
        // Hiển thị thông tin đọc thẻ chip dạng chi tiết
        print("dataNFCResult = \(ICNFCSaveData.shared().dataNFCResult)")
        
        // Hiển thị thông tin POSTCODE
        print("postcodePlaceOfOriginResult = \(ICNFCSaveData.shared().postcodePlaceOfOriginResult)")
        print("postcodePlaceOfResidenceResult = \(ICNFCSaveData.shared().postcodePlaceOfResidenceResult)")
        
        // Hiển thị thông tin ảnh chân dung đọc từ thẻ
        print("imageAvatar = \(ICNFCSaveData.shared().imageAvatar)")
        print("hashImageAvatar = \(ICNFCSaveData.shared().hashImageAvatar)")
        
        // Hiển thị thông tin Client Session
        print("clientSessionResult = \(ICNFCSaveData.shared().clientSessionResult)")
        
        // Hiển thị thông tin đọc dữ liệu nguyên bản của thẻ CHIP: COM, DG1, DG2, … DG14, DG15
        print("dataGroupsResult = \(ICNFCSaveData.shared().dataGroupsResult)")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewShowResult = storyboard.instantiateViewController(withIdentifier: "ResultEkyc") as! ResultEkycViewController
            
            // Thông tin mã QR
            viewShowResult.scanQRCodeResult = ICNFCSaveData.shared().scanQRCodeResult
            
            // Thông tin NFC
            viewShowResult.nfcResult = ICNFCSaveData.shared().dataNFCResult
            
            // Thông tin postcode
            viewShowResult.postcodePlaceOfOrigin = ICNFCSaveData.shared().postcodePlaceOfOriginResult
            viewShowResult.postcodePlaceOfResidence = ICNFCSaveData.shared().postcodePlaceOfResidenceResult
            
            // Thông tin ẢNH chân dung
            viewShowResult.imageAvatar = ICNFCSaveData.shared().imageAvatar
            viewShowResult.hashImageAvatar = ICNFCSaveData.shared().hashImageAvatar
            
            // Thông tin Client Session
            viewShowResult.clientSession = ICNFCSaveData.shared().clientSessionResult
            
            let navigationController = UINavigationController(rootViewController: viewShowResult)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .coverVertical
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
