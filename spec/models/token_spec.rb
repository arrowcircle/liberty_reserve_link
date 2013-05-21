# coding: utf-8

require 'spec_helper'

describe LibertyReserveLink::Token do
  let(:credential) { LibertyReserveLink::Credential.new("account", "secret", "name") }
  let(:token) { LibertyReserveLink::Token.new(credential) }

  it "returns valid hash for balance" do
    expect(token.balance("123").size).to eq 64
  end

  it "returns valid hash for transfer" do
    expect(token.transfer("123", "U343", "usd", "10.0").size).to eq 64
  end

  it "returns valid hash for find_transaction" do
    expect(token.find_transaction("123", "343").size).to eq 64
  end

  it "returns valid hash for history" do
    expect(token.history("123", Date.today, Date.civil(2013, 1, 1)).size).to eq 64
  end

  it "returns valid hash for confirm_transfer" do
    expect(token.confirm_transfer("id", "transfer_id", "confirmation_code").size).to eq 64
  end
end