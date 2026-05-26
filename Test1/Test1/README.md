# Kế Hoạch Triển Khai Tính Năng Mới

Tài liệu này liệt kê **CHỈ NHỮNG TÍNH NĂNG MỚI** cần được làm thêm và merge vào hệ thống hiện tại. Các phần đã hoàn thành (như cấu trúc Canvas, Move, Scale, Rotate, UI Ảnh...) sẽ được tái sử dụng hoàn toàn và không liệt kê lại ở đây.

## 1. Cấu Trúc Thư Mục Mới Cần Bổ Sung
Tuân thủ quy tắc chia Folder của project, ta chỉ tạo thêm các file/folder phục vụ trực tiếp cho yêu cầu mới như sau:

```text
Test1/
├── Models/
│   └── Screen4/
│       └── CustomPhotoPickerModel.swift (Quản lý cấp quyền Photos và lấy dữ liệu PHAsset)
│
├── Views/
│   ├── Screen3/ (Hoặc thả vào chung với Screen2 nếu dùng chung 1 màn hình)
│   │   └── CustomOpacitySlider.swift (Thanh trượt Gradient chỉnh độ mờ ảnh)
│   │
│   └── Screen4/ (Màn hình chọn ảnh tuỳ chỉnh mới)
│       ├── CustomPhotoPicker.swift (Giao diện lưới 3 cột)
│       └── Components/
│           ├── AlbumDropdown.swift (Component chọn thư mục ảnh)
│           └── PhotoGridCell.swift (Từng ô ảnh con có viền xanh chọn nhiều)
```

## 2. Danh Sách Các Chức Năng Cần Làm (To-Do List)

### Giai đoạn 1: Bổ sung tính năng cho Màn Canvas (Screen 3)
- [ ] **Custom Slider:** Code file `CustomOpacitySlider.swift`. Vẽ thanh trượt Gradient Blue-Pink. Code thuật toán cho cục tròn (thumb) đổi màu đồng bộ với đoạn Gradient nằm ngay bên dưới nó.
- [ ] **Tích hợp Opacity:** Kết nối Slider này với Model. Thêm thuộc tính `opacity` vào Model và áp dụng nó lên bức ảnh đang được chọn.
- [ ] **Nút Export (Header):** Đổi nút "Save" thành "Export". Cập nhật code để gọi `UIGraphicsImageRenderer` xuất ra `.jpegData`, sau đó truyền Data này vào `UIActivityViewController` (Bảng Share của iOS).
- [ ] **Nút Add Photo (Bottom):** Sửa hành vi của nút Add. Khi bấm vào, thay vì mở PhotosPicker mặc định của Apple, sẽ mở màn hình `CustomPhotoPicker` (Screen 4).

### Giai đoạn 2: Xây dựng Màn hình chọn ảnh (Screen 4)
- [ ] **Xin quyền Photos:** Khai báo key `NSPhotoLibraryUsageDescription` trong `Info.plist`.
- [ ] **Fetch dữ liệu ảnh:** Khởi tạo `CustomPhotoPickerModel` dùng thư viện `Photos` để quét danh sách Album và load ảnh thumbnail tối ưu bằng `PHImageManager`.
- [ ] **UI Lưới ảnh (Grid):** Dàn layout ảnh thành 3 cột bằng `LazyVGrid`.
- [ ] **Tính năng Đổi Album:** Xây dựng Menu "Recent Photos" để chuyển qua lại giữa các Album trong máy.
- [ ] **Đa lựa chọn (Multi-select):** Xử lý state cho phép chọn nhiều ảnh cùng lúc, thêm viền xanh dương cho ảnh đang chọn.
- [ ] **Merge Dữ liệu:** Bấm "Add" ở Screen 4 sẽ truyền danh sách ảnh được chọn về màn Canvas để thêm vào không gian làm việc.
