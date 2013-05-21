# coding: utf-8

module LibertyReserveLink
  class Credential < Struct.new(:account, :secret, :name)
    def valid?
      valid_field?(account) && valid_field?(secret) && valid_field?(name)
    end

    def valid_field? field
      !field.nil? && !field.empty?
    end
  end
end