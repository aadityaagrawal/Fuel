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

# Database connection parameters
DB_NAME = "your_database_name"
DB_USER = "your_username"
DB_PASSWORD = "your_password"
DB_HOST = "localhost"  # or your remote host
DB_PORT = "5432"

# Directory containing the CSV files
csv_directory = "/path/to/csv/files"

# Establish the connection
conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)
cursor = conn.cursor()

# Function to copy CSV data to PostgreSQL
def copy_csv_to_pg(csv_file, table_name):
    # Load the CSV into a DataFrame
    df = pd.read_csv(csv_file)
    
    # Create table structure (if not exists)
    columns = ", ".join([f"{col} TEXT" for col in df.columns])
    create_table_query = f"""
    CREATE TABLE IF NOT EXISTS {table_name} ({columns});
    """
    cursor.execute(create_table_query)
    conn.commit()

    # Write the DataFrame to PostgreSQL
    for i, row in df.iterrows():
        insert_query = f"INSERT INTO {table_name} VALUES ({', '.join(['%s'] * len(row))})"
        cursor.execute(insert_query, tuple(row))
    conn.commit()

# Loop through all CSV files in the directory
for filename in os.listdir(csv_directory):
    if filename.endswith(".csv"):
        csv_path = os.path.join(csv_directory, filename)
        table_name = filename.replace(".csv", "")  # Name the table same as CSV filename
        print(f"Copying {filename} to table {table_name}...")
        copy_csv_to_pg(csv_path, table_name)

# Close the connection
cursor.close()
conn.close()

print("Data transfer completed.")