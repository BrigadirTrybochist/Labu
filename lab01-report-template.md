# Лабораторна робота 1. Робота з СУБД PostgreSQL та основи SQL

## Загальна інформація

**Здобувач освіти:** Антонюк Андрій
**Група:** ІПЗ-31
**Обраний рівень складності:** 3

## Виконання завдань

### Список таблиць

```sql
-- Запит для отримання списку таблиць
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name; 
```
Результат: У базі даних створено 8 основних таблиць: categories, customers, employees, order_items, orders, products, regions, suppliers.

<img width="197" height="273" alt="image" src="https://github.com/user-attachments/assets/1b113a46-2e7a-45df-90b7-06c8e25e76ca" />

### РІВЕНЬ 1

#### 1. Отримати всі записи з таблиці customers

```sql
SELECT * FROM customers;

```

**Результат:** Отримано всі записи клієнтів бази даних з інформацією про їхні імена, компанії, міста та контактні дані.
<img width="1714" height="502" alt="image" src="https://github.com/user-attachments/assets/29d6ec49-d3b5-4674-b4c0-4f1699cfee8c" />



#### 2. Вивести тільки назви товарів і їхні ціни з таблиці products

```sql
SELECT product_name, unit_price FROM products;

```

**Результат:** Відображено список товарів з відповідними цінами за одиницю (unit_price).

<img width="359" height="818" alt="image" src="https://github.com/user-attachments/assets/636af68a-d0e7-4459-803f-4d940e7304b3" />


#### 3. Показати контактні дані всіх співробітників

```sql
SELECT first_name, last_name, phone, email FROM employees;

```

**Результат:** Отримано таблицю з первинними контактними даними (ім'я, прізвище, телефон, email) усіх працівників.
<img width="453" height="282" alt="image" src="https://github.com/user-attachments/assets/f81b0f5e-afb7-4110-a352-cc8ad620ec09" />


#### 4. Знайти всіх клієнтів з міста Київ

```sql
SELECT * FROM customers WHERE city = 'Київ';

```

**Результат:** Відфільтровано та виведено клієнтів, у яких у полі `city` вказано 'Київ'.
<img width="1547" height="149" alt="image" src="https://github.com/user-attachments/assets/c3b1110b-3308-414e-91c5-7d5ed8e74b74" />


#### 5. Вивести товари, які коштують більше 25000 грн

```sql
SELECT * FROM products WHERE unit_price > 25000;

```

**Результат:** Відображено товари з ціною понад 25 000 грн.
<img width="1839" height="442" alt="image" src="https://github.com/user-attachments/assets/6c5e5534-eefc-48ac-94a4-c65d7d8ab64b" />

#### 6. Показати всі замовлення зі статусом 'delivered'

```sql
SELECT * FROM orders WHERE order_status = 'delivered';

```

**Результат:** Виведено список завершених замовлень зі статусом 'delivered'.
<img width="1613" height="821" alt="image" src="https://github.com/user-attachments/assets/9ac2af7d-a662-49c1-aea9-819aba421a05" />


#### 7. Знайти співробітників, які працюють у відділі продажів

```sql
SELECT * FROM employees WHERE title ILIKE '%продаж%';

```

**Результат:** Знайдено співробітників, посада (`title`) яких пов'язана з відділом продажів.
<img width="1563" height="115" alt="image" src="https://github.com/user-attachments/assets/b30441d6-664b-4d6b-9ad3-72f53f5f4118" />


#### 8. Відсортувати товари за зростанням ціни

```sql
SELECT * FROM products ORDER BY unit_price ASC;

```

**Результат:** Список товарів впорядковано від найдешевшого до найдорожчого.
<img width="1855" height="801" alt="image" src="https://github.com/user-attachments/assets/093c8ab1-4e86-4dd9-81f4-315c7e68c778" />


#### 9. Показати клієнтів в алфавітному порядку за іменем контактної особи

```sql
SELECT * FROM customers ORDER BY contact_name ASC;

```

**Результат:** Записи клієнтів відсортовано за за зростанням літер в полі `contact_name`.
<img width="1714" height="506" alt="image" src="https://github.com/user-attachments/assets/aca8eaa9-e901-4f6c-b800-916ef45fc9a3" />

#### 10. Вивести замовлення від найновіших до найстаріших

```sql
SELECT * FROM orders ORDER BY order_date DESC;

```

**Результат:** Замовлення відсортовано за датою у зворотному порядку (найновіші зверху).
<img width="1615" height="819" alt="image" src="https://github.com/user-attachments/assets/a5b2f34f-b680-4985-8cdb-a74a1e3aeb8a" />


#### 11. Показати перші 10 найдорожчих товарів

```sql
SELECT * FROM products ORDER BY unit_price DESC LIMIT 10;

```

**Результат:** Отримано топ-10 товарів з найвищою вартістю за допомогою комбінації `ORDER BY` та `LIMIT`.
<img width="1819" height="343" alt="image" src="https://github.com/user-attachments/assets/66ed12ff-a441-4dd1-bd21-5c3989f1e9be" />


#### 12. Вивести 5 останніх замовлень (за датою)

```sql
SELECT * FROM orders ORDER BY order_date DESC LIMIT 5;

```

**Результат:** Відображено 5 найбільш свіжих замовлень.
<img width="1475" height="189" alt="image" src="https://github.com/user-attachments/assets/aef94f00-bdab-4429-982f-ebcd1e490d71" />


#### 13. Отримати перших 8 клієнтів в алфавітному порядку

```sql
SELECT * FROM customers ORDER BY contact_name ASC LIMIT 8;

```

**Результат:** Отримано 8 клієнтів за алфавітом.
<img width="1693" height="278" alt="image" src="https://github.com/user-attachments/assets/bdfe98ff-3a24-49a5-8145-20e5707c1dee" />


---

### РІВЕНЬ 2

#### 1. Клієнти, чиї імена починаються на "Іван"

```sql
SELECT * FROM customers WHERE contact_name LIKE 'Іван%';

```

**Результат:** Виведено клієнтів, чиє ім'я починається з шаблону "Іван".
<img width="1385" height="56" alt="image" src="https://github.com/user-attachments/assets/06c0d80d-910b-43c7-aedd-e391f8c9c7c6" />

#### 2. Товари, у назві яких є "phone" або "телефон"

```sql
SELECT * FROM products 
WHERE product_name ILIKE '%phone%' OR product_name ILIKE '%телефон%';

```

**Результат:** Отримано список усіх смартфонів та телефонів у каталозі незалежно від регістру букв.
<img width="1720" height="54" alt="image" src="https://github.com/user-attachments/assets/a68beb31-1f02-4a0f-abb8-b7985d34cf1e" />


#### 3. Товари, що закінчуються на "Pro"

```sql
SELECT * FROM products WHERE product_name ILIKE '%Pro%';

```

**Результат:** Знайдено товари преміум-версій із суфіксом "Pro".
<img width="1740" height="91" alt="image" src="https://github.com/user-attachments/assets/e5411263-69f3-4cad-89df-ca3d46b80447" />


#### 4. Співробітники, прізвище яких починається на "Петр"

```sql
SELECT * FROM employees WHERE last_name LIKE 'Петр%';

```

**Результат:** Відфільтровано співробітників за прізвищем.
<img width="1546" height="58" alt="image" src="https://github.com/user-attachments/assets/47801789-d36d-41af-95dc-70b6d997773a" />


#### 5. Товари, що містять "OLED" у назві

```sql
SELECT * FROM products WHERE product_name ILIKE '%OLED%';

```

**Результат:** Отримано список техніки з OLED-екранами.
<img width="1666" height="119" alt="image" src="https://github.com/user-attachments/assets/114fae14-8d72-409a-8bfa-c22e7b360140" />

#### 6. Товари дорожчі за 15000 грн і дешевші за 50000 грн

```sql
SELECT * FROM products WHERE unit_price > 15000 AND unit_price < 50000;

```

**Результат:** Відфільтровано товари середньої цінової категорії.
<img width="1831" height="531" alt="image" src="https://github.com/user-attachments/assets/036dff67-5abd-47a8-935a-f013f64f62ef" />


#### 7. Клієнти з Києва або Львова, які є юридичними особами (company)

```sql
SELECT * FROM customers 
WHERE (city = 'Київ' OR city = 'Львів') AND customer_type = 'company';

```

**Результат:** Отримано список компаній-клієнтів із міст Київ та Львів.
<img width="1533" height="124" alt="image" src="https://github.com/user-attachments/assets/0f40d318-ef28-43da-a526-209736920c7b" />


#### 8. Активні замовлення (не delivered і не cancelled)

```sql
SELECT * FROM orders 
WHERE order_status NOT IN ('delivered', 'cancelled');

```

**Результат:** Виведено замовлення, які зараз знаходяться в обробці або доставці.
<img width="1482" height="192" alt="image" src="https://github.com/user-attachments/assets/d5129032-fcde-4ce1-b774-6ab103a7e557" />


#### 9. Співробітники з зарплатою понад 25000 грн

```sql
SELECT * FROM employees WHERE salary > 25000;

```

**Результат:** Знайдено працівників з окладом вище 25 000 грн.
<img width="1568" height="117" alt="image" src="https://github.com/user-attachments/assets/5525f195-064d-40ee-aa72-1ff69f420698" />


#### 10. Дорогі товари поза першою категорією

```sql
SELECT * FROM products 
WHERE unit_price > 30000 AND NOT category_id = 1;

```

**Результат:** Отримано дорогі товари з усіх категорій, крім першої.
<img width="1722" height="274" alt="image" src="https://github.com/user-attachments/assets/57b35268-6f3f-4f66-82a6-d64085f0b662" />


#### 11. Замовлення зі статусом 'pending' або 'processing'

```sql
SELECT * FROM orders 
WHERE order_status = 'pending' OR order_status = 'processing';

```

**Результат:** Відфільтровано нові та оброблювані замовлення.
<img width="1482" height="153" alt="image" src="https://github.com/user-attachments/assets/9c9f9e9d-1f17-4136-9548-1043c18ca042" />


#### 12. Клієнти з міст Київ, Харків, Одеса, Дніпро

```sql
SELECT * FROM customers WHERE city IN ('Київ', 'Харків', 'Одеса', 'Дніпро');

```

**Результат:** Отримано клієнтів із найбільших міст України.
<img width="1706" height="409" alt="image" src="https://github.com/user-attachments/assets/493ca6e8-b92f-4dec-970d-a704d33ddacd" />


#### 13. Товари в ціновому діапазоні від 10000 до 30000 грн

```sql
SELECT * FROM products WHERE unit_price BETWEEN 10000 AND 30000;

```

**Результат:** Використано діапазонний оператор `BETWEEN` для вибірки товарів.
<img width="1845" height="432" alt="image" src="https://github.com/user-attachments/assets/78b871e5-cfca-474d-ad49-2ac4c7b6cbcb" />

#### 14. Замовлення з певними статусами (IN)

```sql
SELECT * FROM orders WHERE order_status IN ('pending', 'shipped');

```

**Результат:** Отримано замовлення в статусі очікування або відправлення.
<img width="1475" height="123" alt="image" src="https://github.com/user-attachments/assets/82fc00db-7e78-4215-8ad5-f0eabb4b9300" />


#### 15. Співробітники з міст Київ та Львів

```sql
SELECT * FROM employees WHERE city IN ('Київ', 'Львів');

```

**Результат:** Виведено співробітників з вказаних міст.
<img width="1586" height="215" alt="image" src="https://github.com/user-attachments/assets/71bb8cc0-810b-4f5d-ace2-cefb3777def8" />


#### 16. Замовлення за І квартал 2024

```sql
SELECT * FROM orders WHERE order_date BETWEEN '2024-01-01' AND '2024-03-31';

```

**Результат:** Використано фільтрацію за діапазоном дат.
<img width="1552" height="377" alt="image" src="https://github.com/user-attachments/assets/5e68adad-2e00-4a83-891f-e44ea0fb9eda" />


#### 17. Зарплата від 20000 до 30000 грн

```sql
SELECT * FROM employees WHERE salary BETWEEN 20000 AND 30000;

```

**Результат:** Відфільтровано співробітників за діапазоном зарплати.
<img width="1581" height="217" alt="image" src="https://github.com/user-attachments/assets/43113b1d-33dd-43dd-b22c-403b2e00669a" />


#### 18. Клієнти без компанії (фізичні особи)

```sql
SELECT * FROM customers WHERE company_name IS NULL;

```

**Результат:** Отримано клієнтів, у яких відсутнє значення в полі `company_name` (`IS NULL`).
<img width="1563" height="310" alt="image" src="https://github.com/user-attachments/assets/1843a314-b343-47c8-a95b-9622b251d094" />


#### 19. Замовлення, які вже відправлені (є shipped_date)

```sql
SELECT * FROM orders WHERE shipped_date IS NOT NULL;

```

**Результат:** Знайдено всі відправлені замовлення з заповненою датою відправки (`IS NOT NULL`).
<img width="1599" height="819" alt="image" src="https://github.com/user-attachments/assets/ea2738e2-fa3c-4e2e-be6d-92137ba2514f" />


#### 20. Сортування: Товари за категорією та ціною

```sql
SELECT * FROM products ORDER BY category_id ASC, unit_price DESC;

```

**Результат:** Здійснено багаторівневе сортування: спочатку за категорією, а в межах кожної категорії — від найдорожчого до найдешевшого.
<img width="1857" height="799" alt="image" src="https://github.com/user-attachments/assets/f02b53cb-14be-461d-933c-f4e3d163b903" />


#### 21. Пагінація: Друга сторінка товарів (по 10 позицій)

```sql
SELECT * FROM products ORDER BY product_id LIMIT 10 OFFSET 10;

```

**Результат:** Отримано товари з 11 по 20 за допомогою `LIMIT` та `OFFSET`.
<img width="1861" height="339" alt="image" src="https://github.com/user-attachments/assets/8f40b054-bcb3-4b62-aac7-f3757fb65029" />


---

### РІВЕНЬ 3

#### 1. Товари Samsung або Apple, але не чохол

```sql
SELECT * FROM products 
WHERE (product_name ILIKE '%Samsung%' OR product_name ILIKE '%Apple%') 
  AND product_name NOT ILIKE '%чохол%';

```

**Результат:** Отримано всі гаджети брендів Samsung та Apple, за виключенням аксесуарів (чохлів).
<img width="1818" height="187" alt="image" src="https://github.com/user-attachments/assets/0ac79a69-60f1-44bf-9c60-c8f391cf725e" />


#### 2. Вкладені умови: Дорожчі 20000 (кат. 1 або 2) АБО дешевші 5000 грн

```sql
SELECT * FROM products 
WHERE (unit_price > 20000 AND category_id IN (1, 2)) 
   OR (unit_price < 5000);

```

**Результат:** Використано складне групування умов з дужками `()`, `AND` та `OR`.
<img width="1855" height="391" alt="image" src="https://github.com/user-attachments/assets/6287ce46-0840-440a-9186-f89512c7d0f0" />


#### 3. Креативний запит: Товари з найвищою вартістю залишків на складі

```sql
SELECT product_name, unit_price, units_in_stock, (unit_price * units_in_stock) AS total_value 
FROM products 
ORDER BY total_value DESC 
LIMIT 5;

```

**Результат:** Обчислено сумарну вартість кожного товару на складі (`unit_price * units_in_stock`), створено псевдонім `total_value` та відсортовано за ним top-5 позицій.

<img width="530" height="177" alt="image" src="https://github.com/user-attachments/assets/63c1efd1-bdad-4089-a4f8-b31696dd54c0" />


---

## Висновки

**Самооцінка**: 5

**Обгрунтування**: Роботу виконано в повному обсязі, вивчено базові оператори вибірки даних SQL (`SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `OFFSET`), розібрано роботу з діапазонами (`BETWEEN`), списками (`IN`), невизначеними значеннями (`IS NULL`), текстовими шаблонами (`LIKE`/`ILIKE`) та обчислювальними полями. Запити повністю адаптовані під реальну схему даних `technomart.sql`.

```

```
