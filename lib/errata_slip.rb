# encoding: UTF-8

require 'errata_slip/version'
require 'yaml'

class ErrataSlip

  def self.load_file(filename)
    ErrataSlip.new(YAML::load_file(filename))
  end

  attr_reader :errata

  def initialize(errata)
    @errata = errata
  end

  def correct!(items)
    items.each do |item|
      correct_item!(item)
    end
  end

  def correct_item!(item)
    @errata.each do |errata|
      hash_key_is_symbol = nil
      item.each_key { |k| hash_key_is_symbol = k.is_a?(Symbol); break }
      next unless item_matches_errata(item, errata, hash_key_is_symbol)
      change_fields = errata.keys.select { |field| field[0] == '~' }
      change_fields.map! { |field| field[1..-1]}
      change_fields.each do |field|
        hash_field = hash_key_is_symbol ? field.to_sym : field
        item[hash_field] = errata["~#{field}"]
      end
    end
    item
  end

  def item_matches_errata(hash, errata, hash_key_is_symbol = false)
    find_fields = errata.keys.select { |field| field[0] != '~' }
    find_fields.each do |key|
      hash_key = hash_key_is_symbol ? key.to_sym : key
      return false if hash[hash_key] != errata[key]
    end
    true
  end
end
