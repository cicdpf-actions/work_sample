-- ファイル: v1_0_0__create_initial_schema.sql
-- 説明: データベースの初期スキーマを作成する

-- =============================
-- 1. テーブルの作成
-- =============================

-- ユーザーテーブルの作成
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,       -- ユーザーID（主キー）
    username VARCHAR(50) NOT NULL,    -- ユーザー名
    email VARCHAR(100) NOT NULL,      -- メールアドレス
    password_hash VARCHAR(255) NOT NULL, -- パスワードのハッシュ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 作成日時
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- 更新日時
);

-- ロール（役割）テーブルの作成
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,       -- ロールID（主キー）
    role_name VARCHAR(50) NOT NULL    -- ロール名
);

-- ユーザーとロールのリレーションテーブルの作成
CREATE TABLE user_roles (
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE, -- ユーザーID（外部キー）
    role_id INT REFERENCES roles(role_id) ON DELETE CASCADE, -- ロールID（外部キー）
    PRIMARY KEY (user_id, role_id)                           -- 複合主キー
);

-- =============================
-- 2. インデックスの作成
-- =============================

-- ユーザー名に対する一意制約
CREATE UNIQUE INDEX idx_unique_username ON users (username);

-- メールアドレスに対する一意制約
CREATE UNIQUE INDEX idx_unique_email ON users (email);

-- =============================
-- 3. 初期データの挿入
-- =============================

-- 管理者ロールの挿入
INSERT INTO roles (role_name) VALUES ('admin');

-- 一般ユーザーロールの挿入
INSERT INTO roles (role_name) VALUES ('user');

-- 管理者ユーザーの挿入
INSERT INTO users (username, email, password_hash)
VALUES ('admin', 'admin@example.com', 'hashed_password_here');

-- 管理者に管理者ロールを割り当て
INSERT INTO user_roles (user_id, role_id)
VALUES ((SELECT user_id FROM users WHERE username = 'admin'),
        (SELECT role_id FROM roles WHERE role_name = 'admin'));

-- =============================
-- スキーマ作成の終了
-- =============================

-- スキーマが正常に作成されたことを確認
