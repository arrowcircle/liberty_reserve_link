# LibertyReserveLink

LibertyReserveLink is a library to communicate with [Liberty Reserve](http://libertyreserve.com) API and SCI

## Installation

Add this line to your application's Gemfile:

    gem 'liberty_reserve_link'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install liberty_reserve_link

## Usage

Create a credential object:

	cred = LibertyReserveLink::Credential.new("account_name", "secret", "api_name")
	
For API create Client object:

	api = LibertyReserveLink::Client.new(cred)
	
For SCI create Sci object:

	sci = LibertyReserveLink::Sci.new(cred)
	
## API

To get balance:

	api.balance
	=> {"Euro" => 0.0, "Usd" => 0.0, "GoldGram" => 0.0}
	
	api_balance("usd")
	=> 0.0
	
To make a trasfer:

	api.transfer(receiver, amount, currency, memo)

## SCI

To generate URL to LibertyReserve payment processing:

	sci.payment_uri(amount, currency, order_id, item_name, options={})
	
Options can be one of (See [LR SCI Guide](http://www.libertyreserve.com/en/help/sciguide) for more info):

* `lr_acc_from` - Buyer's account number.
* `lr_comments` - Memo, that Merchant may want to include along with payment.
* `lr_success_url` - URL address of payment successful page at the Merchant's web site.
* `lr_success_url_method` - Payment successful page redirect HTTP method.
* `lr_fail_url` - URL address of payment failed page at the Merchant's web site.
* `lr_fail_url_method` - Payment failed page redirect HTTP method.
* `lr_status_url` - URL address of payment status page at the Merchant's web site or E-mail address to send a successful payment notification via e-mail.
* `lr_status_url_method` - payment status form data transmit HTTP method.

To validate callback from LibertyReserve in controller:

	sci.valid?(params)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
