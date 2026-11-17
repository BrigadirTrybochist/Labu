import psycopg2

class DatabaseConnection:
    def __init__(self):
        self.conn_params = {
            'dbname': 'bookstore',
            'user': 'postgres',
            'password': 'password',
            'host': 'localhost',
            'port': 5432
        }
        self.conn = None

    def connect(self):
        try:
            self.conn = psycopg2.connect(**self.conn_params)
            print("✅ Успішне підключення до бази даних")
        except Exception as e:
            print(f"❌ Помилка підключення: {e}")

    def disconnect(self):
        if self.conn:
            self.conn.close()
            print("🔌 З'єднання закрито")

    def execute_query(self, query, params=None, fetch=False):
        try:
            cur = self.conn.cursor()
            cur.execute(query, params)
            self.conn.commit()
            if fetch:
                return cur.fetchall()
            return cur
        except Exception as e:
            self.conn.rollback()
            print(f"❌ Помилка запиту: {e}")
            return None