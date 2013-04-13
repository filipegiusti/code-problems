require 'benchmark'

PROBLEM_LETTER = 'A'

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

class TicTacToe
  def run(lines)
    lines
  end
end

problem = ProblemSolver.new(TicTacToe.new)
Benchmark.bm do |x|
  x.report("sample\n") { problem.solve("#{PROBLEM_LETTER}-sample-practice.in") }
  x.report("small\n")  { problem.solve("#{PROBLEM_LETTER}-small-practice.in") }
  x.report("large\n")  { problem.solve("#{PROBLEM_LETTER}-large-practice.in") }
end

