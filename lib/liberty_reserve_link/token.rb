# coding: utf-8

class LibertyReserveLink::Token
  def initialize(credential)
    @credential = credential
  end

  def timestamp
    Time.now.utc.strftime("%Y%m%d:%H")
  end

  def secret
    @credential.secret
  end

  def balance(id)
    token = "#{secret}:#{id}:#{timestamp}"
    hash token
  end

  def hash(token)
    Digest::SHA2.hexdigest(token).upcase
  end

  def transfer(id, receiver, currency, amount)
    token = "#{secret}:#{id}:Reference:#{receiver}:#{currency.downcase}:#{amount.is_a?(String) ? amount.to_f.round(2) : amount}:#{timestamp}"
    hash token
  end

  def convert_date(date)
    Time.utc(date.year, date.month, date.day, 0, 0, 0).strftime("%Y-%m-%d %H:%M:%S")
  end

  def history(id, from, till)
    token = "#{secret}:#{convert_date(from)}:#{convert_date(till)}:#{timestamp}"
    hash token
  end

  def find_transaction(id, transaction_id)
    token = "#{secret}:#{id}:#{transaction_id}:#{timestamp}"
    hash token
  end

  def confirm_transfer(id, transfer_id, confirmation_code)
    token = "#{secret}:#{id}:#{transfer_id}:#{confirmation_code}:#{timestamp}"
    hash token
  end
end