import pymysql
import os

# Database configuration
DB_HOST = os.environ.get('DB_HOST') #uses environment variable declared in lambda.tf > aws_lambda_function
DB_USER = 'test'
DB_PASSWORD = 'bananastest'
DB_NAME = 'dbtest'

# SQL query to create the "users" table
CREATE_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS users (
    id INT(11) NOT NULL AUTO_INCREMENT,
    email VARCHAR(255) COLLATE utf8_bin NOT NULL,
    password VARCHAR(255) COLLATE utf8_bin NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=1;
"""

# SQL query to insert a new user
INSERT_USER_SQL = """
INSERT INTO users (email, password) VALUES (%s, %s);
"""

# SQL query to select all rows from "users"
SELECT_USERS_SQL = "SELECT * FROM users;"

def lambda_handler(event, context):
    connection = None  # Prevent UnboundLocalError
    try:
        connection = pymysql.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME,
            cursorclass=pymysql.cursors.DictCursor
        )
        
        with connection.cursor() as cursor:
            cursor.execute(CREATE_TABLE_SQL)
            connection.commit()

            sample_users = [
                ("alice@example.com", "password123"),
                ("bob@example.com", "securepass"),
                ("charlie@example.com", "letmein")
            ]
            
            for user in sample_users:
                cursor.execute(INSERT_USER_SQL, user)
            
            connection.commit()  

            cursor.execute(SELECT_USERS_SQL)
            users = cursor.fetchall() 

        return {
            "statusCode": 200,
            "body": {
                "message": "Table 'users' created and data inserted!",
                "users": users  
            }
        }

    except pymysql.MySQLError as e:
        return {
            "statusCode": 500,
            "body": f" Error: {str(e)}"
        }

    finally:
        if connection:
            connection.close()
