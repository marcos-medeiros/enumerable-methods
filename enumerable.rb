# frozen_string_literal: true

# rubocop:disable Metrics/PerceivedComplexity

# rubocop:disable Metrics/CyclomaticComplexity

module Enumerable
  def my_each
    return to_enum :my_each unless block_given?

    arr = to_a
    length.times { |i| yield arr[i] } unless is_a? Hash
    length.times { |i| yield arr[i][0], arr[i][1] }
    self
  end

  def my_each_with_index
    return to_enum :my_each_with_index unless block_given?

    arr = to_a
    length.times { |i| yield arr[i], i }
    self
  end

  def my_select
    return to_enum :my_select unless block_given?

    if is_a? Hash
      selected = {}
      my_each { |k, v| selection[k] = v if yield k, v }
      return selected
    end
    selected = []
    my_each { |v| selection << v if yield v }
    selected
  end

  def my_count(*args)
    counts = 0
    unless args.empty?
      arg = args[0]
      return counter if is_a? Hash

      my_each { |x| counts += 1 if x == arg }
    end
    if args.positive?
      my_each { |x| counts += 1 if yield x } if block_given?
      return length unless block_given?
    end
    counts
  end
end

# rubocop:enable Metrics/PerceivedComplexity

# rubocop:enable Metrics/CyclomaticComplexity
