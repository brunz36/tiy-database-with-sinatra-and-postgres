require 'sinatra'
require 'pg'

require 'ap'

require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

get '/employees' do
  employees_database = PG.connect(dbname: "tiy_database")

  @employees = employees_database.exec("select * from employees")

  erb :employees
end

get '/show_employee' do
  employees_database = PG.connect(dbname: "tiy_database")

  id = params["id"]

  @employees = employees_database.exec("select * from employees where id = $1", [id])

  employee = @employees.first

  erb :show_employee
end

get '/new_employee' do

  erb :new_employee
end

get '/add_employee' do
  employees_database = PG.connect(dbname: "tiy_database")

  name = params["name"]
  phone = params["phone"]
  address = params["address"]
  position = params["position"]
  salary = params["salary"]
  github = params["github"]
  slack = params["slack"]

  if salary == ""
    redirect to ('/employees')
  else
    employees_database.exec("INSERT INTO employees(name, phone, address, position, salary, github, slack) VALUES ($1, $2, $3, $4, $5, $6, $7)", [name, phone, address, position, salary, github, slack])
    redirect to ('/')
  end
end

get '/search_employee' do
  employees_database = PG.connect(dbname: "tiy_database")

  search = params["search"]

  @employees = employees_database.exec("SELECT * FROM employees WHERE slack = $1 or github = $1 or name LIKE '%#{search}%';", [search])

  employee = @employees.first

  erb :search_employee
end

get '/edit_employee' do
  employees_database = PG.connect(dbname: "tiy_database")

  id = params["id"]

  @employees = employees_database.exec("select * from employees where id = $1", [id])

  erb :edit_employee
end

get '/append_employee' do
  employees_database = PG.connect(dbname: "tiy_database")

  id = params["id"]
  name = params["name"]
  phone = params["phone"]
  address = params["address"]
  position = params["position"]
  salary = params["salary"]
  github = params["github"]
  slack = params["slack"]

  employees_database.exec("UPDATE employees SET name = $1, phone = $2, address = $3, position = $4, salary = $5, github = $6, slack = $7 WHERE id = $8", [name, phone, address, position, salary, github, slack, id])

  @employees = employees_database.exec("select * from employees where id = $1", [id])

  erb :show_employee

end

get '/delete_employee' do
  employees_database = PG.connect(dbname: "tiy_database")

  id = params["id"]

  employees_database.exec("DELETE FROM employees WHERE id = $1", [id])

  redirect to ('/employees')

end
