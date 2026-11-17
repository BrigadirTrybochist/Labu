-- ============================================
-- Тригер 1: Зменшення залишку на складі при покупці
-- ============================================
CREATE OR REPLACE FUNCTION reduce_stock_trigger()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE books 
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE book_id = NEW.book_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_reduce_stock
AFTER INSERT ON order_items
FOR EACH ROW EXECUTE FUNCTION reduce_stock_trigger();

-- ============================================
-- Тригер 2: Заборона зміни ціни більше ніж на 50%
-- ============================================
CREATE OR REPLACE FUNCTION check_price_change_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.price > OLD.price * 1.5 OR NEW.price < OLD.price * 0.5 THEN
        RAISE EXCEPTION 'Ціна не може змінюватися більше ніж на 50%% за один раз';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_price
BEFORE UPDATE ON books
FOR EACH ROW EXECUTE FUNCTION check_price_change_trigger();