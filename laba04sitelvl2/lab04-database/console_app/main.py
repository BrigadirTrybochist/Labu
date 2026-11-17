from database import DatabaseConnection

def show_books(db):
    rows = db.execute_query(
        """SELECT b.book_id, b.title, a.last_name, b.price, b.stock_quantity 
           FROM books b JOIN authors a ON b.author_id = a.author_id 
           ORDER BY b.book_id""", fetch=True)
    if not rows:
        print("Порожньо")
        return
    print(f"\n{'ID':<4} | {'Назва':<30} | {'Автор':<15} | {'Ціна':<8} | {'Склад':<5}")
    print("-" * 75)
    for r in rows:
        print(f"{r[0]:<4} | {r[1][:28]:<30} | {r[2]:<15} | {r[3]:<8} | {r[4]:<5}")

def add_book(db):
    print("\n--- Додавання книги ---")
    title = input("Назва: ")
    isbn = input("ISBN (13 цифр): ")
    year = int(input("Рік: "))
    pages = int(input("Сторінок: "))
    price = float(input("Ціна: "))
    stock = int(input("На складі: "))
    author_id = int(input("ID автора (від 1 до 10): "))
    pub_id = int(input("ID видавництва (від 1 до 10): "))
    genre_id = int(input("ID жанру (від 1 до 10): "))
    
    db.execute_query(
        """INSERT INTO books (title, isbn, publication_year, pages, price, stock_quantity, author_id, publisher_id, genre_id)
           VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)""",
        (title, isbn, year, pages, price, stock, author_id, pub_id, genre_id)
    )
    print("✅ Книгу додано!")

def update_price(db):
    show_books(db)
    book_id = int(input("\nID книги для оновлення: "))
    new_price = float(input("Нова ціна: "))
    db.execute_query("UPDATE books SET price = %s WHERE book_id = %s", (new_price, book_id))
    print("✅ Ціну оновлено!")

def delete_book(db):
    show_books(db)
    book_id = int(input("\nID книги для видалення: "))
    confirm = input(f"Ви впевнені, що хочете видалити книгу ID {book_id}? (так/ні): ")
    if confirm.lower() == 'так':
        db.execute_query("DELETE FROM books WHERE book_id = %s", (book_id,))
        print("✅ Книгу видалено!")

def show_stats(db):
    rows = db.execute_query(
        """SELECT a.last_name, COUNT(b.book_id), AVG(b.price)::NUMERIC(10,2)
           FROM authors a LEFT JOIN books b ON a.author_id = b.author_id
           GROUP BY a.author_id, a.last_name ORDER BY COUNT(b.book_id) DESC""", fetch=True)
    print(f"\n{'Автор':<20} | {'Книг':<6} | {'Сер. ціна':<10}")
    print("-" * 45)
    for r in rows:
        print(f"{r[0]:<20} | {r[1]:<6} | {r[2]:<10}")

def main():
    db = DatabaseConnection()
    db.connect()
    if not db.conn:
        return

    while True:
        print("""
╔══════════════════════════════════════╗
║   КНИЖКОВИЙ МАГАЗИН - КОНСОЛЬ       ║
╠══════════════════════════════════════╣
║ 1. Переглянути книги (Read)          ║
║ 2. Додати книгу (Create)             ║
║ 3. Оновити ціну (Update)             ║
║ 4. Видалити книгу (Delete)           ║
║ 5. Статистика авторів                ║
║ 0. Вихід                             ║
╚══════════════════════════════════════╝""")
        choice = input("Вибір: ")
        
        if choice == '1': show_books(db)
        elif choice == '2': add_book(db)
        elif choice == '3': update_price(db)
        elif choice == '4': delete_book(db)
        elif choice == '5': show_stats(db)
        elif choice == '0': break
        else: print("❌ Невірний вибір!")
        
        input("\nНатисніть Enter для продовження...")

    db.disconnect()

if __name__ == '__main__':
    main()