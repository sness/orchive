#!/usr/bin/ruby

require 'rubygems'
require 'net/http'
require 'pp'


# Development
WEB_SERVER = 'localhost:3000'

# Production
#WEB_SERVER = 'orchive.sness.org'

#
# Description:
#
# Check the job queue for any orcapredict jobs and run the first job we
# find.  When finished, report back to the website that we are finished
# and send it our results.
#

#
# Pseudocode: 
#
# - Check the website to see if there are any jobs that need to get run
# - Make a new temporary run directory in /tmp and cd to there
# - Inform the web server that we are working on this job
# - Run the job
# - Tell the web server we are done running the job
# - Send the results back to the web server
# - Delete the job from the SQS queue
#


#
# Check the website to see if there are any jobs that need to get run
#
q = SQS.get_queue SQS_QUEUE_NAME
m = q.receive_message
if (m.nil?)
  puts "No messages in queue (#{Time.now})"
  exit
end
# The id of the Job on the webserver
job_id = m.body

#
# Make a new temporary run directory in /tmp and cd to there
#
timestamp = Time.now.strftime("/tmp/orcapredict_run_%b%d%y_%I:%M:%S%p").downcase
Dir.mkdir(timestamp)
Dir.chdir(timestamp)

# Are there any messages to process?
if (m.nil?)
  puts "No messages to process"
  exit
else
  puts "Retrieved job_id=(#{job_id})"
end

#
# Inform the web server that we are working on this job
#
puts "Setting state as running"
Net::HTTP.start(WEB_SERVER,80) do |http|
  response,data = http.post("http://#{WEB_SERVER}/run/set_state_as_running/#{job_id}",'')
  if response.code != "200"
    puts "*** Error : Server returned code #{response.code} ***"
    pp response
    pp data
  end
end

  
#
# Run orcapredict on all the target.pdb and ligand.pdb files
#
puts "Running orcapredict"
c = 1
while c <= count do
  system("/home/sness/nDEV/cmd/orcapredict-server/norcapredict --input=orcapredict.in.txt target.#{c}.pdb ligand.#{c}.pdb >> output.txt")
  c += 1
end 


#
# Send the results back to the webserver
#
puts "Sending results to web server"


#
# Delete the job from the SQS queue
#
puts "Deleting job (#{job_id}) from queue"
m.delete

#
# Tell the webserver we have completed running
#
puts "Setting state as completed successfully"
Net::HTTP.start(WEB_SERVER,80) do |http|
  response,data = http.post("http://#{WEB_SERVER}/run/set_state_as_completed_successfully/#{job_id}",'')
  if response.code != "200"
    puts "*** Error : Server returned code #{response.code} ***"
    pp response
    pp data
  end
end


