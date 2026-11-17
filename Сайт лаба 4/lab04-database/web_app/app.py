from flask import Flask, render_template, request, redirect, url_for, flash
import psycopg2

app = Flask(__name__)
app.secret_key = 'super_secret_key'

def get_db_connection():
    return psycopg2.connect(
        dbname='bookstore', user='postgres', password='password',
        host='localhost', port=5432
    )

@app.route('/')
def index():
    return redirect(url_for('books'))

@app.route('/books')
def books():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM view_books_full ORDER BY book_id")
    books_list = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('books.html', books=books_list)

@app.route('/add', methods=['GET', 'POST'])
def add_book():
    if request.method == 'POST':
        try:
            conn = get_db_connection()
            cur = conn.cursor()
            # Викликаємо нашу збережену процедуру
            cur.execute(
                "SELECT add_book_safe(%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                (
                    request.form['title'], request.form['isbn'],
                    int(request.form['year']), int(request.form['pages']),
                    float(request.form['price']), int(request.form['stock']),
                    int(request.form['author_id']), int(request.form['pub_id']),
                    int(request.form['genre_id'])
                )
            )
            conn.commit()
            cur.close()
            conn.close()
            flash('Книгу успішно додано!', 'success')
            return redirect(url_for('books'))
        except Exception as e:
            flash(f'Помилка: {str(e)}', 'error')
            return redirect(url_for('add_book'))

    # Для випадаючих списків (автори, видавництва, жанри)
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT author_id, first_name || ' ' || last_name FROM authors")
    authors = cur.fetchall()
    cur.execute("SELECT publisher_id, name FROM publishers")
    publishers = cur.fetchall()
    cur.execute("SELECT genre_id, name FROM genres")
    genres = cur.fetchall()
    cur.close()
    conn.close()
    
    return render_template('add_book.html', authors=authors, publishers=publishers, genres=genres)

@app.route('/delete/<int:book_id>')
def delete_book(book_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("DELETE FROM books WHERE book_id = %s", (book_id,))
    conn.commit()
    cur.close()
    conn.close()
    flash('Книгу видалено!', 'success')
    return redirect(url_for('books'))

if __name__ == '__main__':
    app.run(debug=True, port=5000)