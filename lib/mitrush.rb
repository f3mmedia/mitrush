require "mitrush/version"

module Mitrush

  def self.snake_to_camel(snake)
    snake.split('_').map { |word| word.capitalize }.join
  end

  def self.stringified_integer?(value)
    /\A[-+]?\d+\z/ === value
  end

  def self.stringified_float?(value)
    /^\d+[.]\d+$/ === value
  end

  def self.valid_json?(json_string)
    return true if JSON.parse(json_string) rescue JSON::ParserError
    false
  end

  def self.delete_keys(hash, keys)
    hash.delete_if { |key, _| keys.include?(key.to_s) || keys.include?(key.to_sym) }
  end

  def self.deep_delete_keys(input, keys)
    if input.is_a?(Array)
      input.each { |item| deep_delete_keys(item, keys) }
    elsif input.is_a?(Hash)
      delete_keys(input, keys)
      input.values.each { |value| deep_delete_keys(value, keys) if [Hash, Array].include?(value.class) }
    end
  end

  def self.deep_symbolise_keys(input)
    update_nested_hash_array(input) { |key, _, new_kvp_hash| new_kvp_hash[:new_key] = key.to_sym rescue key }
  end

  def self.deep_stringify_keys(input)
    update_nested_hash_array(input) { |key, _, new_kvp_hash| new_kvp_hash[:new_key] = key.to_s rescue key }
  end

  def self.deep_stringify_values(input)
    update_nested_hash_array(input) { |_, value, new_kvp_hash| new_kvp_hash[:new_value] = value.to_s rescue value }
  end

  def self.rowify_string(first_string, add_string_hashes, crop_overlength=true)
    new_string = first_string.dup
    current_length = 0
    add_string_hashes.each do |add_string_hash|
      if crop_overlength && current_length + new_string.length > add_string_hash[:start_position] - 3
        new_string = new_string[0..add_string_hash[:start_position] - 4]
      end
      spacer = add_string_hash[:spacer] || ' '
      add_string_hash[:start_position].times do
        new_string = "#{new_string}#{spacer}"
        break if new_string.length >= add_string_hash[:start_position]
      end
      new_string = "#{new_string}#{add_string_hash[:string]}"
    end
    new_string
  end

end
