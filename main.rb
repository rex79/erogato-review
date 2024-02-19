require 'rubyXL'
require 'active_record'
require 'yaml'

require './models.rb'

db_config_file = File.open('database.yaml')
db_config = YAML::load(db_config_file)

#puts main_config
#puts main_config['hub']['Giorgio Ghezzi']

####### BASE SETUP #######

# CreateEmployeeTable.migrate(:down)
# CreateEmployeeTable.migrate(:up)
# CreateEmployeeTable.migrate(:fill_employee_table)
# CreateTimesheetTable.migrate(:down)
# CreateTimesheetTable.migrate(:up)
# CreateTimesheetTable.migrate(:fill_timesheet_table)


