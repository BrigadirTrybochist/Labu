-- ============================================
-- Представлення 1: Всі книги з ПІБ автора
-- ============================================
CREATE OR REPLACE VIEW view_books_full AS
SELECT 
    b.book_id, b.title, a.first_name || ' ' || a.last_name AS author,
    g.name AS genre, b.price, b.stock_quantity
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN genres g ON b.genre_id = g.genre_id;

-- ============================================
-- Представлення 2: Статистика клієнтів
-- ============================================
CREATE OR REPLACE VIEW view_customer_orders AS
SELECT 
    c.first_name || ' ' || c.last_name AS customer,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;