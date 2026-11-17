-- ============================================
-- 1. ПРОСТИЙ ЗАПИТ З ФІЛЬТРАЦІЄЮ (книги дорожчі за 250)
-- ============================================
SELECT title, price, stock_quantity
FROM books
WHERE price > 250
ORDER BY price DESC;

-- ============================================
-- 2. ЗАПИТ З JOIN (книги, їхні автори та жанри)
-- ============================================
SELECT 
    b.title, 
    a.first_name || ' ' || a.last_name AS author,
    g.name AS genre,
    b.price
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN genres g ON b.genre_id = g.genre_id
ORDER BY b.price DESC;

-- ============================================
-- 3. АГРЕГАЦІЙНИЙ ЗАПИТ (статистика по жанрах)
-- ============================================
SELECT 
    g.name AS genre,
    COUNT(b.book_id) AS books_count,
    AVG(b.price)::NUMERIC(10,2) AS avg_price
FROM genres g
LEFT JOIN books b ON g.genre_id = b.genre_id
GROUP BY g.name
HAVING COUNT(b.book_id) > 0
ORDER BY books_count DESC;

-- ============================================
-- 4. ЗАПИТ З ПІДЗАПИТОМ (книги дорожчі за середню ціну)
-- ============================================
SELECT title, price
FROM books
WHERE price > (SELECT AVG(price) FROM books)
ORDER BY price;

-- ============================================
-- 5. СКЛАДНИЙ ЗАПИТ З JOIN ТА АГРЕГАЦІЄЮ 
-- (скільки всього продано книг кожного автора)
-- ============================================
SELECT 
    a.last_name AS author,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.quantity * oi.unit_price)::NUMERIC(10,2) AS total_revenue
FROM authors a
JOIN books b ON a.author_id = b.author_id
JOIN order_items oi ON b.book_id = oi.book_id
GROUP BY a.last_name
ORDER BY total_sold DESC;