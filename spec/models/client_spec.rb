# coding: utf-8

require 'spec_helper'

describe LibertyReserveLink::Client do
  let(:credential) { LibertyReserveLink::Credential.new("U343", "secret", "name") }
  let(:lr) { LibertyReserveLink::Client.new credential }
  let(:common_json) { lr.common_json }

  it "generates valid common json" do
    expect(common_json[:api]).to eq "name"
    expect(common_json[:account]).to eq "U343"
  end
end