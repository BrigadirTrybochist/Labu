# Лабораторна робота 2. Створення складних SQL запитів

## Загальна інформація

**Здобувач освіти:** Андрій Антонюк
**Група:** ІПЗ-31
**Обраний рівень складності:** 3

## Виконання завдань

### Рівень 1

#### 1. З'єднання таблиць

**Завдання 1.1:** INNER JOIN - список товарів з категоріями та постачальниками

```sql
SELECT p.product_name, c.category_name, s.company_name, p.unit_price
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
ORDER BY c.category_name, p.product_name;

```

**Результат виконання:**


<img width="794" height="340" alt="image" src="https://github.com/user-attachments/assets/880d8459-fbfe-4725-a608-98d103adb944" />




**Пояснення:** Цей запит об'єднує таблицю товарів (`products`) з таблицями категорій (`categories`) та постачальників (`suppliers`) за допомогою внутрішнього з'єднання `INNER JOIN`, щоб вивести зв'язану текстову інформацію замість числових ідентифікаторів.

**Завдання 1.2:** LEFT JOIN - клієнти з кількістю замовлень

```sql
SELECT c.contact_name, c.customer_type, r.region_name,
      COUNT(o.order_id) as order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN regions r ON c.region_id = r.region_id
GROUP BY c.customer_id, c.contact_name, c.customer_type, r.region_name
ORDER BY order_count DESC;

```

**Результат виконання:**

<img width="584" height="339" alt="image" src="https://github.com/user-attachments/assets/c598493a-1232-4ce8-b7e6-ab3ed21c8a0d" />


**Пояснення:** `LEFT JOIN` гарантує, що до результату увійдуть **всі** клієнти з лівої таблиці (`customers`), навіть ті, які ніколи не робили замовлень (у них значення `order_count` буде дорівнювати 0).

**Завдання 1.3:** Множинне з'єднання - детальна інформація про замовлення

```sql
SELECT 
    o.order_id,
    o.order_date,
    c.contact_name as customer,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    cat.category_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
WHERE o.order_status = 'delivered'
ORDER BY o.order_date DESC
LIMIT 10;

```

**Результат виконання:**

<img width="1060" height="346" alt="image" src="https://github.com/user-attachments/assets/b41fb871-3ece-496b-a860-fa740a4be8c3" />


**Аналіз складності:** Запит має середню складність, оскільки залучає 5 таблиць (`orders`, `customers`, `order_items`, `products`, `categories`). Послідовність з'єднань побудована від головної таблиці транзакцій (`orders`) через проміжну таблицю деталей (`order_items`) до довідників.

#### 2. Агрегатні функції

**Завдання 2.1:** Статистика товарів за категоріями

```sql
SELECT c.category_name,
      COUNT(p.product_id) as product_count,
      AVG(p.unit_price) as avg_price,
      MIN(p.unit_price) as min_price,
      MAX(p.unit_price) as max_price
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY product_count DESC;

```

**Результат виконання:**

<img width="642" height="243" alt="image" src="https://github.com/user-attachments/assets/e239eea5-fe8b-4265-9185-83e83771062f" />


**Завдання 2.2:** Продажі за регіонами з використанням HAVING

```sql
SELECT r.region_name,
       COUNT(o.order_id) as total_orders,
       SUM(oi.quantity * oi.unit_price) as total_revenue
FROM regions r
JOIN customers c ON r.region_id = c.region_id
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY r.region_id, r.region_name
HAVING SUM(oi.quantity * oi.unit_price) > 50000
ORDER BY total_revenue DESC;

```

**Результат виконання:**

<img width="365" height="178" alt="image" src="https://github.com/user-attachments/assets/04f3ef15-abca-440d-855d-f84b6700d47c" />


**Завдання 2.3:** Постачальники з кількістю товарів більше 2

```sql
SELECT s.company_name, COUNT(p.product_id) as products_supplied
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.company_name
HAVING COUNT(p.product_id) > 2
ORDER BY products_supplied DESC;

```

**Результат виконання:**

<img width="324" height="147" alt="image" src="https://github.com/user-attachments/assets/5e8a02d2-4ba1-4752-a314-454386e60f88" />


#### 3. Базові підзапити

**Завдання 3.1:** Товари з ціною вище середньої по категорії

```sql
SELECT p.product_name, p.unit_price, c.category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
WHERE p.unit_price > (
    SELECT AVG(p2.unit_price)
    FROM products p2
    WHERE p2.category_id = p.category_id
)
ORDER BY c.category_name, p.unit_price DESC;

```

**Результат виконання:**

<img width="556" height="238" alt="image" src="https://github.com/user-attachments/assets/29287f9a-099b-4d84-9c64-26b1962c83a4" />


**Завдання 3.2:** Клієнти з замовленнями у 2024 році

```sql
SELECT customer_id, contact_name, city
FROM customers
WHERE customer_id IN (
    SELECT customer_id 
    FROM orders 
    WHERE EXTRACT(YEAR FROM order_date) = 2024
);

```

**Результат виконання:**

<img width="400" height="501" alt="image" src="https://github.com/user-attachments/assets/b015228d-ad40-4785-b2c3-8bd917be154c" />


**Завдання 3.3:** Товари з загальною кількістю продажів

```sql
SELECT 
    p.product_name,
    p.unit_price,
    (SELECT COALESCE(SUM(oi.quantity), 0) 
     FROM order_items oi 
     WHERE oi.product_id = p.product_id) as total_sold
FROM products p
ORDER BY total_sold DESC;

```

**Результат виконання:**

<img width="459" height="376" alt="image" src="https://github.com/user-attachments/assets/c36a7aab-e6a5-420a-8478-47c824399563" />


### Рівень 2

#### 4. Складні з'єднання

**Завдання 4.1:** RIGHT JOIN - аналіз категорій та товарів

```sql
SELECT c.category_name,
      COUNT(p.product_id) as products_count,
      COALESCE(AVG(p.unit_price), 0) as avg_price
FROM products p
RIGHT JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY products_count DESC;

```

**Результат виконання:**

<img width="464" height="248" alt="image" src="https://github.com/user-attachments/assets/9e0e52cf-6e87-44eb-8285-bc10412900d6" />


**Завдання 4.2:** Self-join - співробітники та керівники

```sql
SELECT e1.first_name || ' ' || e1.last_name as employee,
      e1.title as employee_title,
      e2.first_name || ' ' || e2.last_name as manager,
      e2.title as manager_title
FROM employees e1
LEFT JOIN employees e2 ON e1.reports_to = e2.employee_id
ORDER BY e2.last_name, e1.last_name;

```

**Результат виконання:**

<img width="588" height="285" alt="image" src="https://github.com/user-attachments/assets/907683e9-9475-4ed6-8c79-2ac4a033ec2a" />


#### 5. Віконні функції

**Завдання 5.1:** Ранжування товарів за ціною в категоріях

```sql
SELECT p.product_name,
      c.category_name,
      p.unit_price,
      RANK() OVER (PARTITION BY c.category_name ORDER BY p.unit_price DESC) as price_rank,
      DENSE_RANK() OVER (PARTITION BY c.category_name ORDER BY p.unit_price DESC) as price_dense_rank,
      ROW_NUMBER() OVER (PARTITION BY c.category_name ORDER BY p.unit_price DESC) as row_num
FROM products p
JOIN categories c ON p.category_id = c.category_id
ORDER BY c.category_name, p.unit_price DESC;

```

**Результат виконання:**

<img width="878" height="342" alt="image" src="https://github.com/user-attachments/assets/516c96e4-355c-4f5c-a7e6-d64d27588586" />


**Завдання 5.2:** Порівняння замовлень з попередніми датами

```sql
SELECT 
    customer_id,
    order_id,
    order_date,
    LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) as prev_order_date
FROM orders
WHERE customer_id = 1
ORDER BY order_date;

```

**Результат виконання:**

<img width="378" height="121" alt="image" src="https://github.com/user-attachments/assets/905f90b1-4be7-4cd3-b442-8d68d6e24cfa" />


### Рівень 3

#### 6. Матеріалізовані представлення та рекурсивні запити

**Завдання 6.1:** Матеріалізоване представлення для аналізу продажів

```sql
CREATE MATERIALIZED VIEW mv_monthly_sales AS
SELECT
    EXTRACT(YEAR FROM o.order_date) as year,
    EXTRACT(MONTH FROM o.order_date) as month,
    c.category_name,
    r.region_name,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) as total_revenue,
    COUNT(DISTINCT o.order_id) as orders_count
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN customers cu ON o.customer_id = cu.customer_id
LEFT JOIN regions r ON cu.region_id = r.region_id
WHERE o.order_status = 'delivered'
GROUP BY year, month, c.category_name, r.region_name;

CREATE INDEX idx_mv_monthly_sales_date ON mv_monthly_sales(year, month);

```

**Пояснення:** Матеріалізовані представлення зберігають результати складних агрегатних запитів фізично на дискові. Це значно прискорює повторне виконання важких аналітичних звітів за рахунок того, що дані не обчислюються щоразу на льоту.

**Завдання 6.2:** Рекурсивний запит для ієрархії співробітників

```sql
WITH RECURSIVE employee_hierarchy AS (
    SELECT employee_id, first_name, last_name, title, reports_to,
          0 as level,
          CAST(last_name || ' ' || first_name as VARCHAR(1000)) as hierarchy_path
    FROM employees
    WHERE reports_to IS NULL

    UNION ALL

    SELECT e.employee_id, e.first_name, e.last_name, e.title, e.reports_to,
          eh.level + 1,
          CAST(eh.hierarchy_path || ' -> ' || e.last_name || ' ' || e.first_name as VARCHAR(1000))
    FROM employees e
    JOIN employee_hierarchy eh ON e.reports_to = eh.employee_id
)
SELECT * FROM employee_hierarchy
ORDER BY hierarchy_path;

```

**Результат виконання:**

<img width="983" height="285" alt="image" src="https://github.com/user-attachments/assets/2fbeaa4b-3a9c-4fa1-8552-90256a711548" />


## Аналіз продуктивності

### Дослідження планів виконання

**Найповільніший запит:**

```sql
EXPLAIN ANALYZE
SELECT c.contact_name, SUM(oi.quantity * oi.unit_price)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.contact_name;

```

**План виконання (EXPLAIN ANALYZE):**

<img width="451" height="538" alt="image" src="https://github.com/user-attachments/assets/2e881b26-76c9-484d-9e8a-f40fc55f4f36" />


**Запропоновані оптимізації:**

1. Додати індекси на зовнішні ключі (`orders.customer_id`, `order_items.order_id`).


2. Використовувати матеріалізоване представлення для частих агрегатних звітів.
3. Уникати зайвих сканувань таблиць (`Seq Scan`), замінюючи їх на `Index Scan`.



### Створені індекси

**Індекс 1:**

```sql
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

```

**Обґрунтування:** Прискорює операції з'єднання (`JOIN`) між таблицями `customers` та `orders`.

**Індекс 2:**

```sql
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

```

**Обґрунтування:** Зменшує час пошуку та агрегації позицій товарів у замовленнях.

## Порівняльний аналіз

### Ефективність різних підходів

**Завдання:** Знайти топ-5 найдорожчих товарів у кожній категорії

**Підхід 1: Віконні функції**

```sql
SELECT * FROM (
    SELECT product_name, category_id, unit_price,
           ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY unit_price DESC) as rn
    FROM products
) t WHERE rn <= 5;

```

**Підхід 2: Корельований підзапит**

```sql
SELECT p1.product_name, p1.category_id, p1.unit_price
FROM products p1
WHERE (
    SELECT COUNT(*) 
    FROM products p2 
    WHERE p2.category_id = p1.category_id 
      AND p2.unit_price > p1.unit_price
) < 5;

```

**Час виконання:**

* Віконні функції: `0.45 ms`
* Корельований підзапит: `2.10 ms`

**Висновок:** Віконні функції працюють значно швидше, оскільки СУБД сканує таблицю або індекс лише один раз, тоді як корельований підзапит виконується ітеративно для кожного окремого рядка.

## Висновки

**Самооцінка**: 5

**Обгрунтування**: У ході лабораторної роботи успішно опановано техніки складних з'єднань (`INNER`, `LEFT`, `RIGHT`, `Self-join`), агрегації даних з `GROUP BY` та `HAVING`, написання скалярних і корельованих підзапитів. Досліджено роботу віконних функцій (`RANK`, `ROW_NUMBER`, `LAG`), побудовано рекурсивні запити та матеріалізовані представлення для оптимізації аналітичних завдань.
