-- ============================================
-- Процедура 1: Безпечне додавання книги
-- ============================================
CREATE OR REPLACE FUNCTION add_book_safe(
    p_title VARCHAR, p_isbn VARCHAR, p_year INT, p_pages INT,
    p_price DECIMAL, p_stock INT, p_author_id INT, p_pub_id INT, p_genre_id INT
) RETURNS INT AS $$
DECLARE
    v_book_id INT;
BEGIN
    -- Перевірка, чи не існує вже такої книги
    IF EXISTS (SELECT 1 FROM books WHERE isbn = p_isbn) THEN
        RAISE EXCEPTION 'Книга з ISBN % вже існує', p_isbn;
    END IF;
    -- Перевірка існування автора
    IF NOT EXISTS (SELECT 1 FROM authors WHERE author_id = p_author_id) THEN
        RAISE EXCEPTION 'Автора з ID % не існує', p_author_id;
    END IF;

    INSERT INTO books (title, isbn, publication_year, pages, price, stock_quantity, author_id, publisher_id, genre_id)
    VALUES (p_title, p_isbn, p_year, p_pages, p_price, p_stock, p_author_id, p_pub_id, p_genre_id)
    RETURNING book_id INTO v_book_id;

    RETURN v_book_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Процедура 2: Отримати статистику по авторах
-- ============================================
CREATE OR REPLACE FUNCTION get_authors_stats()
RETURNS TABLE(
    author_name TEXT,
    books_count BIGINT,
    avg_price DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (a.first_name || ' ' || a.last_name)::TEXT,
        COUNT(b.book_id),
        ROUND(AVG(b.price), 2)
    FROM authors a
    LEFT JOIN books b ON a.author_id = b.author_id
    GROUP BY a.author_id, a.first_name, a.last_name
    ORDER BY books_count DESC;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Процедура 3: Оформити замовлення (спрощена)
-- ============================================
CREATE OR REPLACE FUNCTION create_order_safe(
    p_customer_id INT,
    p_book_id INT,
    p_quantity INT
) RETURNS INT AS $$
DECLARE
    v_order_id INT;
    v_price DECIMAL;
    v_stock INT;
BEGIN
    SELECT price, stock_quantity INTO v_price, v_stock FROM books WHERE book_id = p_book_id;
    
    IF v_stock < p_quantity THEN
        RAISE EXCEPTION 'Недостатньо книг на складі';
    END IF;

    INSERT INTO orders (customer_id, status, total_amount)
    VALUES (p_customer_id, 'pending', v_price * p_quantity)
    RETURNING order_id INTO v_order_id;

    INSERT INTO order_items (order_id, book_id, quantity, unit_price)
    VALUES (v_order_id, p_book_id, p_quantity, v_price);

    RETURN v_order_id;
END;
$$ LANGUAGE plpgsql;