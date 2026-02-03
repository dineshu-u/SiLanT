from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/signup', methods=['POST'])
def signup():
    data = request.json  # ✅ no ()

    name = data.get('name')
    email = data.get('email')
    password = data.get('password')

    if not name or not email or not password:
        print("Not successful")  # ✅ executes
        return jsonify({"error": "Missing field"}), 400

    print("Successful signup")  # ✅ executes
    return jsonify({
        "message": "Signup Successful",
        "user": name
    })
@app.route('/signin', methods=['POST'])
def signin():
    data = request.json
    name = data.get('name')
    pwd = data.get('pwd')
    if not name and not pwd:
        return jsonify({"error":"Enter all Mandatory","success":False})
    if not name:
        return jsonify({"error": "Enter your name", "success": False}), 400

    if not pwd:
        return jsonify({"error":"Enter your pwd","success":False}),400
    
    if name and pwd:

        return jsonify({"message": "Signin successful", "success": True})


app.run(host="0.0.0.0", port=5000,debug=True)
