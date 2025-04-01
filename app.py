from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Configuración de la base de datos
app.config['SQLALCHEMY_DATABASE_URI'] = 'mssql+pyodbc://usuario2:usuario2@DESKTOP-7OS5AP9/practica_no2?driver=ODBC+Driver+17+for+SQL+Server'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Modelo de Empleado
class Empleado(db.Model):
    __tablename__ = 'Empleados'  
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100))
    puesto = db.Column(db.String(100))
    salario = db.Column(db.Numeric(10, 2))

# Ruta para listar empleados
@app.route('/')
def index():
    empleados = Empleado.query.all()
    return render_template('index.html', empleados=empleados)

# Ruta para crear un nuevo empleado
@app.route('/create', methods=['GET', 'POST'])
def create():
    if request.method == 'POST':
        nombre = request.form['nombre']
        puesto = request.form['puesto']
        salario = request.form['salario']

        nuevo_empleado = Empleado(nombre=nombre, puesto=puesto, salario=salario)
        db.session.add(nuevo_empleado)
        db.session.commit()

        return redirect(url_for('index'))

    return render_template('create.html')

# Ruta para actualizar un empleado existente
@app.route('/update/<int:id>', methods=['GET', 'POST'])
def update(id):
    empleado = Empleado.query.get_or_404(id)

    if request.method == 'POST':
        empleado.nombre = request.form['nombre']
        empleado.puesto = request.form['puesto']
        empleado.salario = request.form['salario']

        db.session.commit()
        return redirect(url_for('index'))

    return render_template('update.html', empleado=empleado)

# Ruta para eliminar un empleado
@app.route('/delete/<int:id>', methods=['GET', 'POST'])
def delete(id):
    empleado = Empleado.query.get_or_404(id)

    if request.method == 'POST':
        db.session.delete(empleado)
        db.session.commit()
        return redirect(url_for('index'))

    return render_template('delete.html', empleado=empleado)

if __name__ == '__main__':
    # db.create_all()
    app.run(debug=True)