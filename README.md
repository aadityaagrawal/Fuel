# FuelZapp

FuelZapp is a comprehensive mobile application built using Flutter and Firebase that serves as your one-stop solution for all your fuel requirements. Whether you're on a long road trip or just running errands around town, FuelXpress ensures that you never run out of fuel, allowing you to focus on enjoying your journey and creating beautiful memories.

## Features
* **Convenient Fuel Delivery:** Get fuel delivered directly to your location, whether you're at home, at work, or on the road.

* **Seamless Ordering Process:** With just a few taps on your smartphone, you can place an order for fuel delivery and track its progress in real time.

* **Flexible Payment Options:** Choose from a range of payment methods, including credit/debit cards, digital wallets, and cash on delivery.

* **User-Friendly Interface:** Our intuitive app design makes it easy for users to navigate, order fuel, and manage their account settings effortlessly.

* **Future Expansion:** In addition to traditional fuel delivery services, we also plan to introduce movable charging vehicles to cater to electric vehicle (EV) owners, ensuring they never have to worry about running out of battery power.


## Contributing
We welcome contributions from the community to help improve FuelXpress and make it even more robust and user-friendly. If you have any suggestions, bug reports, or feature requests, please feel free to open an issue or submit a pull request.

import psycopg2
import pandas as pd
import os

DB_NAME = "your_database_name"
DB_USER = "your_username"
DB_PASSWORD = "your_password"
DB_HOST = "localhost"
DB_PORT = "5432"

csv_directory = "/path/to/csv/files"

conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)
cursor = conn.cursor()

def copy_csv_to_pg(csv_file, table_name):
    df = pd.read_csv(csv_file)
    df = df.where(pd.notnull(df), None)
    
    columns = ", ".join([f"{col} TEXT" for col in df.columns])
    create_table_query = f"""
    CREATE TABLE IF NOT EXISTS {table_name} ({columns});
    """
    cursor.execute(create_table_query)
    conn.commit()

    for i, row in df.iterrows():
        insert_query = f"INSERT INTO {table_name} VALUES ({', '.join(['%s'] * len(row))})"
        cursor.execute(insert_query, tuple(row))
    conn.commit()

for filename in os.listdir(csv_directory):
    if filename.endswith(".csv"):
        csv_path = os.path.join(csv_directory, filename)
        table_name = filename.replace(".csv", "")
        print(f"Copying {filename} to table {table_name}...")
        copy_csv_to_pg(csv_path, table_name)

cursor.close()
conn.close()

print("Data transfer completed.")