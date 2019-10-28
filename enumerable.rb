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

  def my_map(*args)
    mapped = []
    if args.empty?
      my_each { |v| mapped << yield(v) } unless is_a? Hash
      my_each { |k, v| mapped << yield(k, v) }
    else
      proc = args[0]
      my_each { |v| mapped << proc.call(v) } unless is_a? Hash
      my_each { |k, v| mapped << proc.call(k, v) }
    end
    mapped
  end

  def my_inject(*args)
    arr = to_a
    case args.length
    when 0
      output = arr[0]
      arr.my_each_with_index { |x, i| output = yield(output, x) unless i.zero? }
    when 1
      if args[0].is_a? Integer
        output = args[0]
        arr.my_each { |x| output = yield(output, x) }
        return output
      end
      output = arr[0]
      action = args[0]
      arr.my_each_with_index { |x, i| output = output.method(action).call(x) unless i.zero? }
    when 2
      output = args[0]
      action = args[1]
      arr.my_each { |x| output = output.method(action).call(x) }
    end
    output
  end

  def multiply_els(arr)
    arr.my_inject(:*)
  end

  # Auxiliary methods

  def class_member_pair(_obj1, _obj2, class_type)
    obj1.is_a?(class_type) && obj2.is_a?(class_type)
  end

  def all_class_member?(class_type)
    if is_a? Hash
      my_each { |k, v| return false unless class_member_pair(k, v, class_type) }
    else
      my_each { |v| return false unless v.is_a? class_type }
    end
    true
  end

  def none_class_member?(class_type)
    my_each { |x| return false if x.is_a? class_type } unless is_a? Hash
    true
  end

  def any_class_member?(class_type)
    my_each { |x| return true if x.is_a? class_type }
    false
  end

  def all_eql?(other)
    my_each { |x| return false unless x == other }
    true
  end

  def any_eql?(object)
    my_each { |x| return true if x == object }
    false
  end

  def none_eql?(object)
    my_each { |x| return false if x == object } unless is_a? Hash
    true
  end

  def check_match(regex)
    my_each { |x| return false unless x.match(regex) }
    true
  end

  def any_match?(regex)
    my_each { |x| return true if regex.match(x) }
    false
  end

  def no_match?(regex)
    my_each { |x| return false if x.match(regex) } if is_a? Array
    true
  end
end

# rubocop:enable Metrics/PerceivedComplexity

# rubocop:enable Metrics/CyclomaticComplexity
