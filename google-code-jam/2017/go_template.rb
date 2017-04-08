require 'benchmark'

PROBLEM_LETTER = 'B'

class ProblemSolver
  def initialize(algorithm, case_separator = EmptyLineCaseSeparator.new)
    @algorithm = algorithm
    @case_separator = case_separator
  end

  def solve(dataset)
    File.open(dataset, 'r') do |input|
      File.open(dataset.sub(/\.in/, '.out'), 'w') do |output|
        @case_separator.separate(input) do |test_case, lines|
          result = @algorithm.run(lines)
          output << "Case ##{test_case}: #{result}\n"
        end
      end
    end
  rescue Errno::ENOENT
    puts "Missing #{dataset}"
  end
end

class LineSeparator
  def separate(input)
    test_cases = input.readline.to_i
    1.upto(test_cases) do |num|
      yield(num, [input.readline]) if block_given?
    end
    test_cases
  end
end

class EmptyLineCaseSeparator
  def separate(input)
    test_cases = input.readline.to_i
    1.upto(test_cases) do |num|
      case_lines = []
      while (line = input.readline) != "\n"
        case_lines << line.strip
      end
      yield(num, case_lines) if block_given?
    end
    test_cases
  end
end

class TidyNumber
  def run(lines)
    number = lines.first.chomp
    if number.length == 1
      one_digit(number)
    else
      more_than_one_digit(number)
    end
  end

  def one_digit(number)
    number.to_s
  end

  def more_than_one_digit(number)
    number = number.split("").map!(&:to_i)
    last_digit = number.length - 1

    if number[last_digit] < number[last_digit - 1]
      number[last_digit] = 9
      number[last_digit - 1] = number[last_digit - 1] - 1
    end
    number.join
  end
end

problem = ProblemSolver.new(TidyNumber.new, LineSeparator.new)
Benchmark.bm do |x|
  x.report("sample\n") { problem.solve("#{PROBLEM_LETTER}-sample-practice.in") }
  x.report("small\n")  { problem.solve("#{PROBLEM_LETTER}-small-practice.in") }
  x.report("large\n")  { problem.solve("#{PROBLEM_LETTER}-large-practice.in") }
end

