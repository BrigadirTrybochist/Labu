-- ============================================
-- Таблиця авторів (довідник)
-- ============================================
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,          -- Унікальний ідентифікатор (автоінкремент)
    first_name VARCHAR(50) NOT NULL,       -- Ім'я (обов'язкове)
    last_name VARCHAR(50) NOT NULL,        -- Прізвище (обов'язкове)
    country VARCHAR(50),                   -- Країна
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Дата додавання
);

-- ============================================
-- Таблиця видавництв (довідник)
-- ============================================
CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,       -- Унікальний ідентифікатор
    name VARCHAR(100) NOT NULL UNIQUE,     -- Назва (унікальна, обов'язкова)
    email VARCHAR(100) CHECK (email LIKE '%@%.%') -- Email з перевіркою формату
);

-- ============================================
-- Таблиця жанрів (довідник)
-- ============================================
CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,           -- Унікальний ідентифікатор
    name VARCHAR(50) NOT NULL UNIQUE       -- Назва жанру (унікальна)
);

-- ============================================
-- Таблиця книг (центральна сутність)
-- ============================================
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,            -- Унікальний ідентифікатор
    title VARCHAR(200) NOT NULL,           -- Назва книги
    isbn VARCHAR(13) UNIQUE NOT NULL,      -- ISBN (унікальний, 13 символів)
    publication_year INT CHECK (publication_year > 1000), -- Рік видання
    pages INT CHECK (pages > 0),           -- Кількість сторінок (додатне число)
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0), -- Ціна (не від'ємна)
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0), -- Залишок на складі
    author_id INT NOT NULL REFERENCES authors(author_id),       -- Зовнішній ключ до авторів
    publisher_id INT NOT NULL REFERENCES publishers(publisher_id), -- Зовнішній ключ до видавництв
    genre_id INT NOT NULL REFERENCES genres(genre_id)           -- Зовнішній ключ до жанрів
);

-- ============================================
-- Таблиця клієнтів (довідник)
-- ============================================
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,        -- Унікальний ідентифікатор
    first_name VARCHAR(50) NOT NULL,       -- Ім'я
    last_name VARCHAR(50) NOT NULL,        -- Прізвище
    email VARCHAR(100) UNIQUE NOT NULL,    -- Email (унікальний, обов'язковий)
    phone VARCHAR(20)                      -- Телефон
);

-- ============================================
-- Таблиця замовлень (транзакційна)
-- ============================================
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,           -- Унікальний ідентифікатор
    customer_id INT NOT NULL REFERENCES customers(customer_id), -- Зовнішній ключ до клієнтів
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Дата створення
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')), -- Статус з обмеженням
    total_amount DECIMAL(10, 2) DEFAULT 0 CHECK (total_amount >= 0) -- Загальна сума
);

-- ============================================
-- Таблиця позицій замовлень (зв'язок N:M)
-- ============================================
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,      -- Унікальний ідентифікатор
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE, -- Видаляється разом із замовленням
    book_id INT NOT NULL REFERENCES books(book_id), -- Зовнішній ключ до книг
    quantity INT NOT NULL CHECK (quantity > 0),    -- Кількість (більше 0)
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0) -- Ціна на момент покупки
);