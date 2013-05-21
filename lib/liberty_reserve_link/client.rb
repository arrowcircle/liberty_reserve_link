# coding: utf-8

require 'digest'
require 'bigdecimal'
require 'httparty'
require 'json'

module LibertyReserveLink

  class Client

    class InvalidCredentialException < Exception; end

    FORMAT = :json
    API_HOST = "https://api2.libertyreserve.com"

    include HTTParty
    format FORMAT
    base_uri API_HOST

    attr_reader :credential

    def initialize(credential)
      @credential = credential
      check_credential
      @token = LibertyReserveLink::Token.new @credential
    end

    def check_credential
      raise InvalidCredentialException unless @credential.valid?
    end

    def api_path(operation)
      "/json/#{operation}"
    end

    def common_json
      {:account => @credential.account, :api => @credential.name}
    end

    def parse_balance(currency, resp)
      if resp["Balance"]
        if currency
          resp["Balance"][currency]
        else
          resp["Balance"]
        end
      else
        nil
      end
    end

    def balance(currency=nil)
      id = random_id
      parse_balance currency, Client.post(api_path("balance"), :query => common_json.merge({:id => id, :token => @token.balance(id)}))
    end

    def transfer(receiver, amount, currency, memo)
      id = random_id
      query = common_json.merge({
          :id => id,
          :token => @token.transfer(id, receiver, currency, amount),
          :reference => "Reference",
          :type => "transfer",
          :payee => receiver,
          :currency => currency,
          :amount => (amount.is_a?(String) ? amount.to_f.round(2) : amount),
          :memo => memo,
          :purpose => "service"
      })
      JSON.parse Client.post(api_path("transfer"), :query => query).to_json
    end

    def transaction(transaction_id)
      id = random_id
      JSON.parse Client.post(api_path("findtransaction"), :query => common_json.merge({:token => @token.find_transaction(id, transaction_id), :id => id, :batch => transaction_id.to_s})).to_json
    end

    # auth error here
    def name(account)
      id = random_id
      JSON.parse Client.post(api_path("accountname"), :query => common_json.merge({:id => id, :token => @token.balance(account), :search => account})).to_json
    end

    # Returns the history for an account given a currency as an array of transactions,
    # see +get_transaction+ for the transaction format.
    # Direction
    # +direction+ can be any of :incoming, :outgoing, :any
    def get_history(currency, till = DateTime.now, from = DateTime.now.advance(days: -14), options = {})
      defaults = {
        direction: 'any',
        page_size: 20,
        page_number: 1
      }

      opts = defaults.merge(options)

      raise ArgumentError unless [:any, :outgoing, :incoming].include?(opts[:direction].to_sym)

      r = send_request("history") do |xml|
        xml.HistoryRequest :id => random_id do
          authentication_block(xml)
          xml.History do
            xml.CurrencyId currency
            xml.From from.strftime("%Y-%d-%m 00:00:00")
            xml.Till till.strftime("%Y-%d-%m 23:59:59")
            xml.CorrespondingAccountId opts[:corresponding_account_id] if opts[:corresponding_account_id]
            xml.TransferType opts[:transfer_type] if opts[:transfer_type]
            xml.Source opts[:source] if opts[:source]
            xml.Direction opts[:direction].to_s
            xml.AccountId @account
            xml.Pager do |pager|
              pager.PageSize opts[:page_size]
              pager.PageNumber opts[:page_number]
            end
          end
        end
      end

      if r["HistoryResponse"]["Pager"]["TotalCount"] != "0"
        [r["HistoryResponse"]["Receipt"]].flatten.map { |t| format_transaction(t) }.compact
      else
        []
      end
    end


    private

      def random_id
        (rand * 10 ** 9).to_i
      end
  end
end

