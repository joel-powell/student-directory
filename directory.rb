require "csv"

@students = [] # an empty array accessible to all methods

def print_menu
  puts [
    "1. Input students",
    "2. Show students",
    "3. Save list to file",
    "4. Load list from file",
    "9. Exit" # 9 because we'll be adding more items
  ]
end

def interactive_menu
  loop do
    print_menu
    process($stdin.gets.chomp)
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
  name = $stdin.gets.chomp
  cohort = :november
  student = [name, cohort]
  # while the name is not empty, repeat this code
  until name.empty?
    add_students(student)
    puts "Now we have #{@students.count} students"
    # get another name from the user
    name = $stdin.gets.chomp
  end
end

def add_students(student)
  name, cohort = student
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
  puts "-------------"
end

def enter_filename
  puts "Please enter a CSV filename"
  $stdin.gets.chomp
end

def save_students
  filename = enter_filename
  save_to_file(filename)
end

def load_students
  filename = enter_filename
  try_load_students(filename)
end

def start_load_students
  filename = ARGV.shift || "students.csv" # first cli argument or default
  try_load_students(filename)
end

def try_load_students(filename)
  if File.exist?(filename)
    load_from_file(filename)
    student_count = CSV.read(filename).length
    puts "Loaded #{student_count} from #{filename}"
    puts "Now we have #{@students.count} students"
  else
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end

def save_to_file(filename)
  CSV.open(filename, "wb") do |csv|
    @students.each do |student|
      csv << student.values
    end
  end
end

def load_from_file(filename)
  CSV.foreach(filename) do |row|
    add_students(row)
  end
end

start_load_students
interactive_menu
