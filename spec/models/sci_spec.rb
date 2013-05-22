# coding: utf-8

require 'spec_helper'

describe LibertyReserveLink::Sci do
  let(:credential) { LibertyReserveLink::Credential.new("account", "secret", "name") }
  let(:sci) { LibertyReserveLink::Sci.new(credential) }
  let(:sci_options) { sci.escape_options options }
  let(:options) { {:valenok => "valenok", :test => "test", :lr_success_url => "url"} }

  it "filter options" do
    expect(sci_options.keys).to eq [:lr_success_url]
  end

  it "returns hash" do
    expect(sci.hash("test")).to eq "9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08"
  end
end