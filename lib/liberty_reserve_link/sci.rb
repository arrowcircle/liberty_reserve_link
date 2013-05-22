# coding: utf-8

class LibertyReserveLink::Sci

  ENDPOINT = 'https://sci.libertyreserve.com'
  ALLOWED_OPTIONS = %w{lr_acc_from lr_comments lr_success_url lr_success_url_method lr_fail_url lr_fail_url_method lr_status_url lr_status_url_method}

  def initialize(credential)
    @credential = credential
    check_credential
  end

  def check_credential
    raise LibertyReserveLink::Client::InvalidCredentialException unless @credential.valid?
  end

  def account
    @credential.account
  end

  def name
    @credential.name
  end

  def secret
    @credential.secret
  end

  def escape_options options
    options.reject {|k, v| !(ALLOWED_OPTIONS.include? k.to_s)}
  end

  def payment_uri(amount, currency, order_id, item_name, options={})
    endpoint = URI.parse ENDPOINT
    @query = {lr_acc: account, lr_store: name, lr_amnt: amount,
              lr_currency: currency, lr_merchant_ref: order_id,
              item_name: item_name, order_id: order_id
              }.merge(escape_options(options))
    endpoint.query = @query.to_query
    endpoint.to_s
  end

  def hash(input)
    Digest::SHA256.new.digest(input).unpack('H*').first.upcase
  end

  def prepare_string(params)
    "#{account}:#{params[:lr_paidby]}:#{name.gsub(/\\\//, '')}:#{params[:lr_amnt]}:#{params[:lr_transfer]}:#{params[:lr_currency]}:#{secret}"
  end

  def valid?(params)
    params[:lr_encrypted] == hash(prepare_string(params)) && params[:lr_paidto] == account
  end
end