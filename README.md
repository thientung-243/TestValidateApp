# 📥 iOS Video Downloader

Ứng dụng iOS cho phép người dùng **tải video từ URL**, theo dõi tiến trình tải, huỷ tải nếu muốn, và xem lại video đã tải xuống ngay cả khi offline.

---

## 🎯 Tính năng chính

✅ Nhập URL video để tải  
✅ Kiểm tra URL hợp lệ và không trùng lặp  
✅ Hiển thị tiến trình tải (% và thanh progress)  
✅ Hỗ trợ huỷ tải giữa chừng  
✅ Lưu video vào Documents Directory  
✅ Danh sách video đã tải (có thể xem lại offline)  
✅ Vuốt để xoá video khỏi danh sách và bộ nhớ

---

## 🛠 Công nghệ sử dụng

- Swift 5+
- UIKit
- URLSession + URLSessionDownloadTask
- FileManager
- AVPlayer (xem video offline)
- UITableView

---

## 🚧 Luồng hoạt động

1. **Người dùng nhập URL**
   - Kiểm tra URL hợp lệ (`isValidURL`)
   - Kiểm tra đã tồn tại video này chưa (dựa vào tên file)
![Màn hình tải video](screenshot4.png)
2. **Tiến trình tải video**
   - Sử dụng `URLSessionDownloadTask`
   - Hiển thị `UIProgressView` và phần trăm
   - Có nút "Huỷ" để dừng tải
![Ấn huỷ để dừng tải](screenshot1.png)
3. **Sau khi tải xong**
   - Lưu file vào `Documents/DownloadedVideos`
   - Thêm tên file vào danh sách
![Màn hình video đã tải](screenshot2.png)
4. **Hiển thị danh sách video đã tải**
   - `UITableView` với tên và ngày tải
   - Vuốt để xoá file khỏi app và hệ thống
![X  á video đã tải](screenshot4.png)
5. **Phát video offline**
   - Nhấn vào video trong danh sách
   - Dùng `AVPlayerViewController` để phát
![Xem video offline](screenshot1=5.png)
---

## 📂 Cấu trúc thư mục lưu video

- Mỗi video được lưu tại thư mục Documents trong FileManager
