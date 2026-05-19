# 🚀 Project: SwiftUI Photo Editor

Ứng dụng quản lý dự án và chỉnh sửa ảnh trên Canvas, được xây dựng bằng SwiftUI hỗ trợ **iOS 17+** sử dụng macro `@Observable` và hệ thống `@Environment`.

## 📂 Cấu trúc Dự án hiện tại
Dự án đã được quy hoạch theo mô hình Feature-based (chia theo màn hình):
- **Models/**: Chia thành `Screen1` và `Screen2` (CanvasModel).
- **Views/**: 
    - `Screen1`: Danh sách dự án.
    - `Screen2`: Giao diện Editor (chia nhỏ thành `Header`, `Middle`, `Bottom`).
- **Services/**: `APIService` xử lý networking.

---

## ✅ Những thứ ĐÃ CÓ (Screen 1 - Project List)
1. **Dữ liệu (Data):**
   - Đã kết nối thành công API GET `xproject`.
   - Sử dụng macro `@Observable` trong `ProjectModel` để quản lý danh sách dự án toàn cục.
2. **Giao diện (UI):**
   - Danh sách dự án hiển thị đẹp mắt với bo góc và màu sắc hiện đại.
   - Nút **"Add Project"** cố định ở đáy màn hình.
3. **Tính năng:**
   - **Add Project:** Mở popup Alert, nhập tên và lưu vào Store.
   - **Remove Project:** Tính năng **Custom Swipe** mượt mà, cho phép vuốt trái để hiện nút Delete.
   - **Navigation:** Nhấn vào một dự án đã chuyển hướng sang màn hình chi tiết (Screen 2).

---

## 🛠 Những thứ CÒN THIẾU & CẦN LÀM (Screen 2 - Photo Editor)
Đây là phần trọng tâm tiếp theo của dự án:

### 1. Networking & Model
- [x] Hoàn thiện `ProjectDetailModel`: Định nghĩa struct `Photo` và `Frame` để hứng dữ liệu Canvas.
- [x] Viết hàm **POST** `postAPI(projectId:)` trong `APIService`.
  - **URL:** `https://tapuniverse.com/xprojectdetail`
  - **Method:** `POST`
  - **Body (raw):** `{"id": 21}`
  - **Response Structure:**
    ```json
    {
        "name": "Travel",
        "id": 21,
        "photos": [
            {
                "url": "...",
                "frame": { "x": 200, "y": 100, "width": 100, "height": 200 }
            }
        ]
    }
    ```

### 2. Giao diện Canvas
- [x] Dựng màn hình chính `ProjectDetailView` và chia nhỏ các thành phần UI:
    - `ProjectDetailHeader`: Nút back.
    - `ProjectDetailMiddle`: Vùng làm việc Canvas.
    - `ProjectDetailBottom`: Nút Add Photo.
- [x] Hiển thị danh sách ảnh từ API theo đúng toạ độ `x, y, width, height`.

### 3. Hệ thống Cử chỉ (Gestures) - **Quan trọng nhất**
- [ ] **Zoom Canvas:** Sử dụng 2 ngón tay để thu phóng toàn bộ vùng làm việc.
- [x] **Di chuyển ảnh:** Chạm và kéo 1 ngón tay để thay đổi vị trí ảnh.
- [x] **Chọn ảnh:** Chạm vào ảnh để hiện viền xanh và nút xoá.
- [x] **Resize & Rotate:** Dùng 2 ngón tay để xoay và thay đổi kích thước ảnh (phải giữ đúng tỷ lệ - Aspect Ratio).

### 4. Tính năng chỉnh sửa
- [ ] **Add Photo:** Chọn ảnh từ thư viện máy và đưa vào tâm màn hình.
- [ ] **Delete Photo:** Nhấn nút `(-)` để xoá ảnh khỏi Canvas.
- [ ] **Save & Back:** Nhấn Back để lưu lại toàn bộ vị trí ảnh và quay về Screen 1.

---

## 📝 Ghi chú Kỹ thuật
- **State Management:** Sử dụng macro `@Observable` (ProjectModel, CanvasModel) để quản lý logic và dữ liệu, truyền qua `@Environment`.
- **Target OS:** iOS 17.0+ (Sử dụng `NavigationStack` và các API hiện đại của iOS 17).
- **Networking:** Hàm `postAPI(projectId:)` trong `APIService` xử lý việc lấy dữ liệu chi tiết.
- **Persistence:** Cần chú ý việc đồng bộ dữ liệu giữa Client và Server khi thực hiện các hành động chỉnh sửa.
