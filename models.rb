require 'active_record'

db_config_file = File.open('database.yaml')
db_config = YAML.load(db_config_file)

ActiveRecord::Base.establish_connection(db_config)
ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

class CreateEmployeeTable < ActiveRecord::Migration[5.2]

  def up
    return if ActiveRecord::Base.connection.table_exists?(:employees)

    create_table :employees do |table|
      table.string :name
      table.string :scheduler
      table.string :controller
      table.string :hub
      table.timestamps
    end
  end

  def down
    return unless ActiveRecord::Base.connection.table_exists?(:employees)

    drop_table :employees
  end

  def fill_employee_table
    main_config = YAML.load(File.open('config.yaml'))
    employee = RubyXL::Parser.parse(main_config['emp_folder'])
    emp_sheet = employee['MS']
    x = 1
    while x < emp_sheet.count
      if main_config['hub_scheduler'][emp_sheet[x][1].value] # skip not alfa,beta,gamma,delta employee
        Employee.create({
                          name: emp_sheet[x][0].value,
                          scheduler: emp_sheet[x][1].value,
                          controller: main_config['hub_performance'][main_config['hub_scheduler'][emp_sheet[x][1].value]],
                          hub: main_config['hub_scheduler'][emp_sheet[x][1].value]
                        })
      end
      x += 1
    end
  end
end

class CreateTimesheetTable < ActiveRecord::Migration[5.2]
  def up
    return if ActiveRecord::Base.connection.table_exists?(:timesheets)

    create_table :timesheets do |table|
      table.string :data
      table.string :name
      table.string :hub
      table.string :project
      table.string :cliente
      table.integer :hours
      table.integer :days
      table.text :prj_type
      table.text :prj_hub
      table.timestamps
    end
  end

  def down
    return unless ActiveRecord::Base.connection.table_exists?(:timesheets)

    drop_table :timesheets
  end

  def fill_timesheet_table
    main_config = YAML.load(File.open('config.yaml'))
    employee = RubyXL::Parser.parse(main_config['erogato_folder'])
    ts_sheet = employee['erogato']
    x = 1
    while x < ts_sheet.count
      # search if employee is on hub (no staff)
      emp = Employee.find_by(name: ts_sheet[x][1].value)
      unless emp.nil?
        Timesheet.create({
          data: ts_sheet[x][0].value,
          name: ts_sheet[x][1].value,
          hub: ts_sheet[x][2].value,
          project: ts_sheet[x][6].value,
          cliente: ts_sheet[x][4].value,
          hours: ts_sheet[x][8].value,
          days: (ts_sheet[x][8].value/8),
          prj_type: ts_sheet[x][13].value,
          prj_hub: emp.hub
        })
      end
      x += 1
    end
  end
end

class Employee < ActiveRecord::Base
end

class Timesheet < ActiveRecord::Base
end
