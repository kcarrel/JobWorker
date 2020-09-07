require 'pry'
class CLI
  def welcome
    puts "Welcome to the Gravitational Code Challenge!"
    menu
  end

  def menu
    puts "-----> What would you like to do?"
    puts "-----> Type the number (0-4) that best describes your desired action."
    puts "0. exit"
    puts "1. Start a job"
    puts "2. Stop a job"
    puts "3. Query a job"
    puts "4. Get ouput of a running job"
    answer = gets.chomp.downcase
    case answer
    when "0"
      puts "Goodbye!"
      nil
    when "1"
      puts "-----> Wonderful! Which job would you like to start?"
      job = gets.chomp.downcase
      make_call("command","start", job)
    when "2"
      display_pids("stop")
    when "3"
      display_pids("query")
    when "4"
      display_pids("log")
    else
      puts "That was not a valid answer. Please try again!"
      menu
    end
  end

  #Make menu options more modular with this reused function
  #for options that require seeing the pids
  def display_pids(action)
    puts "-----> Wonderful! What is the PID of the job you would like to #{action}?"
    output = IO.read("jobs.txt")
    puts "#{output}"
    job = gets.chomp.downcase
    make_call("pid",action, job)
  end

  #Make menu options more modular with this reused function
  def make_call(action, endpoint, job)
    response = HTTParty.post(
      "http://localhost:3000/#{endpoint}",
      :body =>  {
        "#{action}" => "#{job}",
        "client" => "client_cert.pem",
      }
    )
    puts response
    menu
  end
end
