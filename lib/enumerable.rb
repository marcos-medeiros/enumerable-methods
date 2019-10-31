# frozen_string_literal: true

# rubocop:disable Metrics/PerceivedComplexity

# rubocop:disable Metrics/CyclomaticComplexity

# rubocop:disable Metrics/ModuleLength

module Enumerable
  def my_each
    return to_enum :my_each unless block_given?

    arr = to_a
    length.times { |i| yield arr[i] } unless is_a? Hash
    length.times { |i| yield arr[i][0], arr[i][1] } if is_a? Hash
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
      my_each { |k, v| selected[k] = v if yield k, v }
      return selected
    end
    selected = []
    my_each { |v| selected << v if yield v }
    selected
  end

  def my_count(item = nil)
    count = 0
    if block_given?
      my_each { |item_| count += 1 if yield(item_) }
    elsif item
      my_each { |item_| count += 1 if item_ == item }
    else
      count = length
    end
    count
  end

  def my_map
    return to_enum unless block_given?

    array = []
    my_each { |i| array << yield(i) }
    array
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

  def my_all?(*args)
    return true if to_a.empty?

    unless args.empty?
      arg = args[0]
      return all_class_member?(arg) if arg.is_a? Class
      return check_match(arg) if arg.is_a? Regexp

      return all_eql? arg
    end

    if block_given?
      my_each { |v| return false unless yield v } unless is_a? Hash
      my_each { |k, v| return false unless yield k, v } if is_a? Hash
    else
      is_a?(Array) ? my_each { |v| return false unless v } : true
    end
    true
  end

  def my_any?(*args)
    return false if to_a.empty?

    unless args.empty?
      arg = args[0]
      return any_class_member?(arg) if arg.is_a? Class
      return any_match?(arg) if arg.is_a? Regexp

      return any_eql? arg
    end

    if block_given?
      my_each { |v| return true if yield v } unless is_a? Hash
      my_each { |k, v| return true if yield k, v } if is_a? Hash
    else
      return true if is_a? Hash

      my_each { |v| return true if v }
    end
    false
  end

  def my_none?(pattern = nil)
    if block_given?
      my_each { |obj| return false if yield(obj) }
    elsif pattern
      my_each do |obj|
        return false if matchers?(obj, pattern)
      end
    else
      my_each { |obj| return false if obj }
    end
    true
  end

  # Auxiliary methods for my_all?, my_none? and my_any? methods

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

  def check_match(regex)
    my_each { |x| return false unless x.match(regex) }
    true
  end

  def any_match?(regex)
    my_each { |x| return true if regex.match(x) }
    false
  end

  def matchers?(obj, pattern)
    (obj.respond_to?(:eql?) && obj.eql?(pattern)) ||
      (pattern.is_a?(Class) && obj.is_a?(pattern)) ||
      (pattern.is_a?(Regexp) && pattern.match(obj))
  end

end

def multiply_els(arr)
  arr.my_inject(:*)
end

# rubocop:enable Metrics/PerceivedComplexity

# rubocop:enable Metrics/CyclomaticComplexity

# rubocop:enable Metrics/ModuleLength
