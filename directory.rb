require 'csv'

@students = [] # an empty array accessible to all methods

def print_menu
  puts [
         "1. Input the students",
         "2. Show the students",
         "3. Save the list to students.csv",
         "4. Load the list from students.csv",
         "9. Exit" # 9 because we'll be adding more items
       ]
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def process(selection)
  case selection
  when "1"
    input_students
  when "2"
    show_students
  when "3"
    save_students
  when "4"
    load_students
  when "9"
    exit # terminate program
  else
    puts "I don't know what you meant, try again"
  end
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  # get the first name
  name = STDIN.gets.chomp
  cohort = :november
  # while the name is not empty, repeat this code
  until name.empty?
    add_students(name, cohort)
    puts "Now we have #{@students.count} students"
    # get another name from the user
    name = STDIN.gets.chomp
  end
end

def add_students(name, cohort)
  # add the student hash to the array
  @students << { name: name, cohort: cohort }
end

def show_students
  print_header
  print_student_list
  print_footer
end

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print_student_list
  @students.each do |student|
    puts "#{student[:name]} (#{student[:cohort]} cohort)"
  end
end

def print_footer
  puts "Overall, we have #{@students.count} great students"
end

def save_students
  CSV.open("students.csv", "wb") do |csv|
    @students.each do |student|
      csv << student.values
    end
  end
end

def load_students(filename = "students.csv")
  CSV.foreach(filename) do |name, cohort|
    add_students(name, cohort)
  end
end

def try_load_students
  filename = ARGV.shift || "students.csv" # first argument from the command line or default

  if File.exist?(filename) # if it exists
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else # if it doesn't exist
    puts "Sorry, #{filename} doesn't exist."
    exit # quit the program
  end
end

try_load_students
interactive_menu
