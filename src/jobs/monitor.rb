require 'tiny_tds'
require 'yaml'

DBCONFIG = YAML.load_file('dbconfig.yml')

#puts DBCONFIG

def get_db(dbname)
  TinyTds::Client.new(
    :azure => true,
    :host => DBCONFIG['host'],
    :database => dbname,
    :username => DBCONFIG['username'],
    :password => DBCONFIG['password']
  )
end

# http://msdn.microsoft.com/library/azure/ff394114.aspx
# DBSIZE_SQL = %q{
# }.strip()

dbusage = []
# missing samples are considered zero value
DBUSAGE_SQL = %q{
select top(1)
 convert(date, start_time)  as [day]
,datepart(hour, start_time) as [hour]
,min(start_time)            as [first_sample_time]
,max(end_time)              as [last_sample_time]
,count(*)                   as [sample_count]
,sum(avg_cpu_percent)/12                as [avg_cpu_percent]
,sum(avg_physical_data_read_percent)/12 as [avg_physical_data_read_percent]
,sum(avg_log_write_percent)/12          as [avg_log_write_percent]
from sys.resource_stats
-- only full hours
where start_time < dateadd(hour, datediff(hour, 0, getdate()), 0)
group by convert(date, start_time), datepart(hour, start_time)
order by [day] desc, [hour] desc
}.strip() % DBCONFIG['database']

#puts DBUSAGE_SQL

prev_storage_in_megabytes = 0
curr_storage_in_megabytes = 0

prev_active_session_count = 0
curr_active_session_count = 0

masterdb = get_db 'master'
# slavedb = get_db DBCONFIG['database']

SCHEDULER.every '60s' do

  if not masterdb.active?
    puts "\e[31mmaster no more active, resetting connection\e[0m"
    masterdb = nil
    masterdb = get_db 'master'
  end

  if dbusage.empty?
    puts "TODO: empty, init structure now just dummy"
    dbusage = [1]
  end

  result = masterdb.execute(DBUSAGE_SQL)
  result.each do |row|
    prev_storage_in_megabytes = curr_storage_in_megabytes
    curr_storage_in_megabytes = row['storage_in_megabytes'].round(1)
    send_event('storage_in_megabytes', { current: curr_storage_in_megabytes,
                                         last: prev_storage_in_megabytes })

    prev_active_session_count = curr_active_session_count
    curr_active_session_count = row['active_session_count']
    send_event('active_session_count', { current: curr_active_session_count,
                                         last: prev_active_session_count })

    send_event('avg_cpu_percent', { value: row['avg_cpu_percent'] })
    send_event('avg_physical_data_read_percent', { value: row['avg_physical_data_read_percent'] })
    send_event('avg_log_write_percent', { value: row['avg_log_write_percent'] })
  end

  # if not slavedb.active?
  #   puts "\e[31mslave (%s) no more active, resetting connection\e[0m" % DBCONFIG['database']
  #   slavedb = nil
  #   slavedb = get_db DBCONFIG['database']
  # end

end
