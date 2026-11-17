# Лабораторна робота №4 — Система обліку книжкового магазину

## 📌 Про проєкт
Цей репозиторій містить виконання лабораторної роботи №4 (Рівень 2). 
Предметна область: **Система обліку книжкового магазину**.

## 📖 Документація
Уся детальна інформація, опис концептуальної моделі, логічної схеми, скріншоти та висновки знаходяться у звіті:

👉 **[Переглянути звіт (docs/report.md)](docs/report.md)**

## 🛠 Технології
- **База даних:** PostgreSQL 17 (Docker)
- **Мова програмування:** Python 3.11+
- **Бібліотеки:** `psycopg2-binary`, `Flask`
- **Розгортання:** Docker Compose

## 🚀 Як запустити проєкт

1. **Встановіть необхідні бібліотеки:**
   Відкрийте термінал у кореневій папці проєкту та виконайте:
   `pip install -r requirements.txt`

2. **Запустіть базу даних (потрібен Docker):**
   `docker compose up -d`
   *База даних автоматично ініціалізується таблицями та тестовими даними при першому запуску.*

3. **Запуск консольного застосунку:**
   `cd console_app`
   `python main.py`

4. **Запуск вебзастосунку:**
   `cd web_app`
   `python app.py`
   *Після запуску веб-інтерфейс буде доступний у браузері за адресою: http://127.0.0.1:5000*

## 📁 Структура проєкту

```text
lab04-database/
├── .gitignore
├── README.md
├── requirements.txt
├── docker-compose.yml
│
├── docs/
│   ├── conceptual_model.png
│   └── report.md          <-- Звіт
│
├── database/
│   ├── 01_create_tables.sql
│   ├── 02_insert_data.sql
│   ├── 03_create_procedures.sql
│   ├── 04_create_triggers.sql
│   ├── 05_create_views.sql
│   └── queries.sql
│
├── console_app/
│   ├── database.py
│   └── main.py
│
└── web_app/
    ├── app.py
    └── templates/
        ├── add_book.html
        └── books.html
