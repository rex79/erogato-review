require 'active_record'
require 'rubyXL'

def buildTable(db,hub,input_array)
    thimesheet_folder   = "/Users/robertosigalotti/Arsenalia GmbH/alpenite it - project managers - 2024/accounting/erogato/2024___ALPENITE___hr.analytic.timesheet.xlsx"
    mscheduling_folder  = "/Users/robertosigalotti/Arsenalia GmbH/alpenite-it - hub container - 2024 - Documents/2024/00-cross/02-scheduling/04-kpi/#{input_array[0]}/elaborazione/erogato-rielaborato.xlsx"
    puts "PARSING TIMESHEET FILES (could take a while)"
    timesheet = RubyXL::Parser.parse(thimesheet_folder)
    #employee = RubyXL::Parser.parse(mscheduling_folder)
    puts "END PARSING TIMESHEET FILES"

    begin
        db.execute 'DROP TABLE IF EXISTS timesheet'
        db.execute 'CREATE TABLE IF NOT EXISTS timesheet (id INTEGER PRIMARY KEY,
            data TEXT NOT NULL,
            month TEXT NOT NULL,
            nome TEXT NOT NULL,
            emplyee TEXT NOT NULL,
            project TEXT NOT NULL,
            qty INTEGER NOT NULL,
            days INTEGER NOT NULL,
            amount INTEGER NOT NULL,
            description TEXT NOT NULL,
            prj_type VARCHAR,
            prj_hub VARCHAR)'
=begin
        db.execute 'DROP TABLE IF EXISTS employee'
        db.execute 'CREATE TABLE IF NOT EXISTS employee(id INTEGER PRIMARY KEY,
            nome VARCHAR NOT NULL,
            scheduler VARCHAR NOT NULL,
            hub VARCHAR NOT NULL)'

        emp_sheet = employee['MS']
        x = 1
        while (x < emp_sheet.count)
            if hub[emp_sheet[x][1].value] # skip not alfa,beta,gamma,delta employee
                db.execute "INSERT INTO employee (nome,scheduler,hub) VALUES(?,?,?)", emp_sheet[x][0].value,emp_sheet[x][1].value,hub[emp_sheet[x][1].value]
            end
            x += 1
        end
=end
        ts_sheet = timesheet['erogato']
        x = 1
        while (x < ts_sheet.count)
            query = "SELECT hub FROM employee WHERE nome=?"
            hub_name = db.get_first_value query, ts_sheet[x][4].value
            if hub_name
                query = "INSERT"
                db.execute
            end
            x += 1
        end
    rescue SQLite3::Exception => e
        puts e.inspect
    end
end