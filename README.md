# 💊 Pharma POS

## 💻 Flutter POS Desktop Application | Offline Mode with Cloud Sync (Pharmacy Edition)

Pharma POS is a Flutter-based point-of-sale desktop application designed specifically for pharmacies. It enables smooth sales operations both **offline and online**, with intelligent cloud sync and multi-terminal support.

---

## 📝 Description

Pharma POS allows pharmacies to continue operations during internet outages, with automatic data synchronization when back online.

### Key Features:
- Fully functional **offline mode**
- **Automatic cloud sync** of transactions and stock
- Supports **multiple POS terminals** within a single store
- **Conflict resolution** for stock discrepancies between offline and online sales
- **Admin Panel** for product and inventory management

---

## 🧪 User Experience (UX)

Designed for speed and simplicity at the pharmacy counter:

- 🔎 Quick product search by name or barcode  
- ➕ Add items to cart instantly  
- 🔁 Adjust quantities directly in cart  
- 🛒 Clear cart overview: name, price, quantity, subtotal  
- 💵 Fast and simple invoice finalization  
- ⚙️ **Admin Tools**: Easily add, edit, or remove products from inventory  

---

## 🎯 Project Objectives

- Develop a **multi-tab POS** using Flutter Desktop  
- Enable **offline sales** with **local database storage**  
- **Sync all data** with the cloud bi-directionally  
- Provide an optimized **pharmacy-specific interface**  
- Introduce an **Admin interface** for product management  

---

## ✅ Acceptance Criteria

### 📴 Offline Mode
- Sales, search, and checkout work without internet  
- Local access to product data: name, barcode, stock, price  
- Transactions are stored locally  

### 💽 Local Storage
- Cart and invoice data saved to a **local database**  
- Stock updates applied locally upon sale  
- Product catalog (added by Admin) is stored locally  

### ☁ Cloud Sync
- Unsynced sales are synced to the cloud when online  
- Stock levels are updated across terminals  
- Supports multiple terminals syncing in one store  
- Admin product updates (new items, price changes, stock updates) sync to all devices  

### 👨‍💼 Admin Product Management
- Admin can **add new products** with details:
  - Name  
  - Barcode  
  - Category  
  - Purchase price & selling price  
  - Stock quantity  
  - Expiry date (optional)  
- Admin can **edit or remove existing products**  
- Product changes **sync across all terminals**  
- Local database updated instantly for offline use  

---

## ⚠ Challenge Point: Stock Conflict in Offline Mode

While offline, POS terminals operate on a local copy of the stock. If multiple terminals sell the same item independently (online/offline), discrepancies may arise.  

The app is designed to handle such **conflict resolution** when syncing back to the cloud, ensuring inventory accuracy across all terminals.

---

## 📦 Technologies Used

- Flutter (Desktop)  
- Hive (Local storage)  
- Cloud Firestore  
