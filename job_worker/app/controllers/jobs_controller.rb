require 'open4'
require 'byebug'
require 'async'
class JobsController < ApplicationController
  # only allow access to these endpoints after authorization/authentication step
  #write PIDs to a jobs.txt file after PID is available as a way to avoid a data race with returning the PID
  def start
    Async do |task|
      pid, stdin, stdout, stderr = Open4::popen4 " #{params[:command]}"
      log = File.new("jobs.txt", 'a')
      log.write("PID: #{pid}\n")
      log.close
      output = File.new("#{pid}.log", 'a')
      output.write("#{stdout.read.strip}")
      output.close
    end
    render json: { message: "Command received - a signal has been sent to start the job!"}
  end

  def stop
    # Prototype Limitation/TODO: In production SIGKILL would not be used and SIGTERM would
    pid, stdin, stdout, stderr = Open4::popen4 "kill -9 #{params[:pid]}"
    ignored, status = Process::waitpid2 pid
    case status.exitstatus
    when 0
      render json: { message: "The job has been stopped."}
    else
      render json: { message: "Failed to  send a signal to stop the job."}
    end
  end

  def query
    pid = `#{params[:pid]}`.to_i
    ignored, status = Process::waitpid2 pid
    case status.exitstatus
    when 0
      render json: { message: "The job ran and exited successfully!" }
    else
      render json: { message: "The job failed and did not exit successfully."}
    end
  end

  #get output of a running job
  def log
    @output = IO.read("#{params[:pid]}.log")
    render json: { output: @output}
  end
end
