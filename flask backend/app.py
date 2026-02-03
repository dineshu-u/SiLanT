from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
CORS(app)


# -------- MySQL Connection --------
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="0402",
    database="auth_db"
)
cursor = db.cursor(dictionary=True)


# -------- SIGNUP --------
@app.route('/signup', methods=['POST'])
def signup():
    data = request.json or {}

    name = data.get('name')
    email = data.get('email')
    password = data.get('password')
    c_password=data.get('c_password')
    print(name)
    errors={}
    if not name:
        errors["name"]="name required"
    if not email:
        errors["email"]="email required"
    if not password:
        errors["password"]="password required"
    if password!=c_password:
        return jsonify({"success":"false","error":"pwd not matches with confirm pwd"}),400

        
    if not name or not email or not password:
        return jsonify({"success": False, "error": "Missing fields"}), 400

    # check if email already exists
    cursor.execute("SELECT id FROM users WHERE email=%s", (email,))
    if cursor.fetchone():
        return jsonify({"success": False, "error": "Email already exists"}), 400

    hashed_pwd = generate_password_hash(password)

    cursor.execute(
        "INSERT INTO users (name, email, pwd) VALUES (%s, %s, %s)",
        (name, email, hashed_pwd)
    )
    db.commit()

    return jsonify({"success": True, "message": "Signup successful"}), 201


# -------- SIGNIN --------
@app.route('/signin', methods=['POST'])
def signin():
    data = request.json or {}

    email = data.get('email')
    pwd = data.get('pwd')

    errors = {}

    if not email:
        errors["email"] = "email required"
    if not pwd:
        errors["pwd"] = "password required"

    if errors:
        return jsonify({"success": False, "errors": errors}), 400

    cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
    user = cursor.fetchone()

    if not user:
        return jsonify({
            "success": False,
            "errors": {"email": "email not registered"}
        }), 400

    if not check_password_hash(user["pwd"], pwd):
        return jsonify({
            "success": False,
            "errors": {"pwd": "incorrect password"}
        }), 400

    return jsonify({"success": True, "message": "login successful"}), 200


# -------- RUN SERVER --------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
