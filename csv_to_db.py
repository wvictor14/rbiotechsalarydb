import polars as pl
import os


def read_csv(file):
    return pl.read_csv(file, infer_schema_length=10000)


def filter(df):
    out = df.select(
        pl.col(
            [
                "date",
                "location_country",
                "location_granular",
                "title_category",
                "title_general",
                "salary_total",
                "salary_base",
                "bonus_pct",
                "experience_highest_degree",
                "years_of_experience",
                "company_or_institution_name",
            ]
        )
    )
    return out


def populate_db(df):
    DB_CONFIG = {
        "host": os.getenv("DB_HOST", "postgres"),
        "database": os.getenv("DB_NAME", "mydb"),
        "user": os.getenv("DB_USER", "user"),
        "password": os.getenv("DB_PASSWORD", "password"),
        "port": os.getenv("DB_PORT", "5432"),
    }
    TABLE_NAME = "salaries"
    PG_URL = f"postgresql://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"

    try:
        df.write_database(
            table_name=TABLE_NAME,
            connection=PG_URL,
            engine="adbc",
            if_table_exists="replace",
        )
        print(f"DataFrame successfully written to PostgreSQL table '{TABLE_NAME}'.")
    except Exception as e:
        print(f"Error writing DataFrame to database: {e}")


def main():
    FILE_CSV = "https://raw.githubusercontent.com/wvictor14/rbiotechsalarydata/refs/heads/main/salary_results_cleaned.csv"
    df = read_csv(FILE_CSV)
    df = filter(df)
    populate_db(df)


if __name__ == "__main__":
    main()
