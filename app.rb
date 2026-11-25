require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader

    def db
      return @db if @db

      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end

    get '/todos' do    
        @todos = db.execute('SELECT * FROM todos')  
        ap @todos  
        erb(:'todos/index')
    end

    get '/todos/new' do
        erb(:'todos/new')
    end

    post '/todos' do
        name = params['name']
        description = params['description']
        db.execute('INSERT INTO todos (name, description) VALUES (?, ?)', [name, description])
        redirect('/todos')
    end


    get '/todos/:id' do
        id = params['id'].to_i
        @todo  = db.execute('SELECT * FROM todos WHERE id = ?', [id]).first
        ap @todo
        erb(:'todos/show')
    end

end