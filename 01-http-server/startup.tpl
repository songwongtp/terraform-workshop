#!/bin/bash

apt-get update -y
apt-get install virtualenv python3.8 -y

mkdir "${project}_project"
cd "${project}_project/"

mkdir ${project}

virtualenv venv
source venv/bin/activate

pip install flask flask-wtf

cd ${project}
mkdir templates

cat > __init__.py << EOF
from flask import Flask
app = Flask(__name__)
from ${project} import views
EOF

cat > views.py << EOF
from ${project} import app
from flask import render_template
@app.route('/')
def index():
    return render_template('index.html')
EOF

cat > run.py << EOF
import os
import sys
sys.path.append(os.path.dirname(os.getcwd()))
from ${project} import app
if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=${port})
EOF

cat > templates/base.html << 'EOF'
<!DOCTYPE html>
<html>
    <head>
    {% block head %}
    {% endblock %}
    </head>
    
    <body>
    {% block content %}
    {% endblock %}
    </body>
</html>
EOF

cat > templates/index.html << EOF
{% extends 'base.html' %}
{% block content %}
    <h1>${project}</h1>
    <img src="${image}" alt="example" width="500" height="600">
{% endblock %}
EOF

pip freeze > requirements.txt
python3 run.py
