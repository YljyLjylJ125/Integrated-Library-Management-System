# Library Management System 

A web-based **Library Management System** developed for **City University of Hong Kong (Dongguan)**. This system facilitates book management, user borrowing workflows, and administrative tasks using a **Vue.js** frontend and a **Flask** backend with **MySQL** database.

## Table of Contents
- Features [<sup>1</sup>](#-features)
- Tech Stack [<sup>2</sup>](#-tech-stack)
- Project Structure [<sup>3</sup>](#-project-structure)
- Database Schema [<sup>4</sup>](#-database-schema)
- Prerequisites [<sup>5</sup>](#-prerequisites)
- Installation & Setup [<sup>6</sup>](#-installation--setup)
- API Endpoints [<sup>7</sup>](#-api-endpoints)
- Troubleshooting [<sup>8</sup>](#-troubleshooting)

---

## Features

### User Portal (`MyUser.vue`)
- **Browse Books**: View available books (`UserShop.vue`).
- **Borrowing**: Submit borrow requests (On-site or Online Reservation).
- **My Borrowings**: Track borrow status:
  - **Pending**: Requests waiting for admin approval (`UserUnsend.vue`).
  - **Processing**: Approved requests currently being handled (`UserSending.vue`).
  - **Completed**: Books successfully borrowed (`UserFinished.vue`).
- **Personal Center**: View profile (`IndiMsg.vue`) and change password (`ChPwd.vue`).

###  Admin Portal (`MyManage.vue`)
- **Book Management**: Add, edit, or delete books (`ManageShop.vue`).
- **Staff Management**: Manage library staff and librarians (`ManageServer.vue`, `ManageDispatcher.vue`).
- **Workflow Management**:
  - **UnSend**: View new borrow requests (`UserUnsend.vue` equivalent on admin side).
  - **BeSending**: Assign librarians to pending requests.
  - **WuliuUnended**: Mark processing tasks as "Delivered/Picked Up".
  - **WuliuEnded**: View completed borrows and **Return Books** (Archive).

### Authentication (Local Demo)

- **Login**: Role-based login (Reader/Admin).
- **Registration**: *Simulated interface only*. Actual account creation relies on database insertion.

---

## Tech Stack

| Component    | Technology                  |
| :----------- | :-------------------------- |
| **Frontend** | Vue.js 2, Element UI, Axios |
| **Backend**  | Python 3, Flask, SQLAlchemy |
| **Database** | MySQL 8.0+                  |
| **Cache**    | Redis                       |

---

## Project Structure

### Backend
```
backend/
├── app.py                # Main Flask application entry point & API routes
├── auth.py               # Token generation and verification logic (JWT)
├── config.py             # Database configuration (MySQL connection string)
├── main.py               # Simple script entry (optional)
├── library.sql           # Database initialization script
└── requirements.txt      # Python dependencies
```

### Frontend (Vue Components)
```
frontend/src/components/
├── MyLogReg.vue          # Login & Registration Page
├── MyManage.vue          # Admin Dashboard Container
├── MyUser.vue            # User Dashboard Container
│
├── ManageShop.vue        # Admin: Book Management
├── ManageServer.vue      # Admin: Library Staff Management
├── ManageDispatcher.vue  # Admin: Librarian Management
│
├── ManageWuliu/          # Admin: Workflow Handling
│   ├── WuliuUnended.vue  # Mark tasks as completed
│   └── WuliuEnded.vue    # View completed history & Return books
│
├── ManageOrder/          # Admin: Order Views
│   ├── UnSend.vue        # View Processing Orders (Name mismatch in code, logic is Processing)
│   ├── BeSending.vue     # View Pending Orders & Assign Librarian
│   └── BeSended.vue      # View Finished Orders
│
├── UserOrder/            # User: Borrow Status
│   ├── UserUnsend.vue    # Pending Requests
│   ├── UserSending.vue   # Processing Requests
│   └── UserFinished.vue  # Completed Requests
│
├── UserMsg/              # User: Personal Settings
│   ├── IndiMsg.vue       # Profile Info
│   └── ChPwd.vue         # Change Password
│
└── UserShop.vue          # User: Browse & Borrow Books
```

---

## Database Schema
The system uses **MySQL**. Import `library.sql` to initialize tables:

- **`user`**: Login credentials (Role: 0=Reader, 1=Admin).
- **`user_profile`**: Detailed user info.
- **`book`**: Book inventory.
- **`borrow_order`**: Main transaction table (Status: 0=Pending, 1=Processing, 2=Finished, 3=Returned).
- **`borrow_log`**: Audit log for librarian actions.
- **`librarian`**: Admin staff handling borrows.

---

## Prerequisites
1. **Node.js** & **npm** (for Frontend)
2. **Python 3.8+** (for Backend)
3. **MySQL Server** running on localhost.
4. **Redis** (Optional, based on `config.py`).

---

## Installation & Setup

### 1. Database Setup
1. Open your MySQL client (e.g., Navicat, Workbench).
2. Create a database named `library`.
3. Run the SQL script provided in `library.sql` to create tables and views.

### 2. Backend Setup
1. Navigate to the backend directory.
2. Install dependencies:
   ```bash
   pip install flask flask-cors flask-sqlalchemy pymysql redis
   ```
   *(Or use `pip install -r requirements.txt` if available)*
3. **Configure Database**:
   Open `config.py` and update your MySQL credentials:
   ```python
   USERNAME = "root"
   PASSWORD = "your_password"  # <--- Change this
   ```
4. Run the server:
   ```bash
   python app.py
   ```
   *Server runs at `http://127.0.0.1:5000`*

### 3. Frontend Setup
1. Navigate to the frontend directory.
2. Install dependencies:
   ```bash
   npm install
   ```
3. Run the development server:
   ```bash
   npm run serve
   ```
   *Frontend runs at `http://localhost:8080` (usually)*

---

## Usage & Login Guide (IMPORTANT)

Since the SMS service is not connected for this local demo, **you cannot register a new account via the frontend verification code**. 

Please use the **default accounts** provided in `library.sql` or manually add records to the `user` table in your database.

### Default Accounts

| Role       | Phone Number (Login ID) | Password    | Description                                                  |
| :--------- | :---------------------- | :---------- | :----------------------------------------------------------- |
| **Admin**  | `18067311581`           | `123456789` | Has access to `MyManage` backend. Linked to Librarian `L001`. |
| **Reader** | `13936295057`           | `abcdef`    | Has access to `MyUser` frontend for borrowing books.         |

### How to Add a New User (Manually)

To add a new user, execute the following SQL command in your database tool:

```sql
-- Role: 0 for Reader, 1 for Admin
INSERT INTO user (username, password, telephone, role) 
VALUES ('new_user', 'password123', '13800138000', 0);

-- (Optional) Add profile info
INSERT INTO user_profile (id, real_name, sex, age, email, phone, username)
VALUES (LAST_INSERT_ID(), 'New User', 'Male', 20, 'new@test.com', '13800138000', 'new_user');
```

---

## API Endpoints (Key Examples)

| Method   | Endpoint                      | Description                       |
| :------- | :---------------------------- | :-------------------------------- |
| **POST** | `/api/user/login`             | User/Admin Login                  |
| **GET**  | `/api/user/books`             | Get book list                     |
| **POST** | `/api/user/borrow`            | Submit borrow request             |
| **GET**  | `/api/manager/pending_borrow` | Get pending requests (Admin)      |
| **POST** | `/api/manager/assign_borrow`  | Assign librarian to request       |
| **POST** | `/api/manager/finish_task`    | Mark borrowing as delivered       |
| **POST** | `/api/manager/return_book`    | **Return book** (Archives record) |

---

## Troubleshooting

1. **CORS Errors**:
   - Ensure `flask-cors` is installed and `CORS(app)` is enabled in `app.py`.
2. **Database Connection Failed**:
   - Check `config.py`. Ensure MySQL is running on port 3306.
3. **Login Fails**:
   - Check the `user` table. Default admin: `alice` / `123456789`.
   - Ensure `auth.py` is present for token generation.
4. **Menu Not Working**:
   - In `MyManage.vue` and `MyUser.vue`, ensure `handleselect` casts index to Number: `this.active = Number(index);`.

---

**Developed for CityU (Dongguan) Library System Project.**