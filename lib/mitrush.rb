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

  def self.update_nested_hash_array(input, manual_recursion=false, &block)
    if input.is_a?(Array)
      output = []
      input.each { |item| output << update_nested_hash_array(item, manual_recursion, &block) }
    elsif input.is_a?(Hash)
      output = {}
      input.each do |key, value|
        hash_array = nil
        if value.is_a?(Array) || value.is_a?(Hash) && !manual_recursion
          hash_array = update_nested_hash_array(value, manual_recursion, &block)
        end
        new_kvp_hash = {new_key: key, new_value: value}
        yield(key, value, new_kvp_hash)
        output[new_kvp_hash[:new_key] || key] = hash_array || new_kvp_hash[:new_value] || value
      end
    else
      output = input
    end
    output
  end

  def self.tablify(table_rows, column_formats)
    table_string_array = table_rows.map do |table_row|
      unless table_row.length == column_formats.length
        raise 'table_row array lengths must each match column_formats array length'
      end
      table_row_hashes = []
      table_row.each_with_index do |column_string, i|
        table_row_hashes << column_formats[i].update(string: column_string)
      end
      rowify(table_row_hashes)
    end
    table_string_array.join("\n")
  end

  def self.rowify(table_row_hashes)
    table_row_string_array = table_row_hashes.map do |column_hash|
      column_string = column_hash[:string].is_a?(String) ? column_hash[:string].dup : column_hash[:string].to_s
      if column_string.length > column_hash[:width] - 3
        column_string = column_string[0..column_hash[:width] - 3]
      end
      column_hash[:width].times do
        column_string = "#{column_string}#{column_hash[:spacer] || ' '}"
        break if column_string.length >= column_hash[:width]
      end
      column_string
    end
    table_row_string_array.join
  end

end
