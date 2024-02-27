require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader'
require './models.rb'


get '/erogato-commesse' do
    ts_gamma = Timesheet.select(:project).distinct

    clienti = []
    ts_gamma.each do |cliente|
        unless cliente.project.empty?
            clienti.push(cliente.project)
        end
    end

    json clienti.to_json
end