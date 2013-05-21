# coding: utf-8

require 'spec_helper'

describe LibertyReserveLink::Credential do
  context "valid?" do
    let(:valid_credential) { LibertyReserveLink::Credential.new("account", "secret", "name").valid? }
    let(:no_name) { LibertyReserveLink::Credential.new("account", "secret", nil).valid? }
    let(:no_secret) { LibertyReserveLink::Credential.new("account", nil, "name").valid? }
    let(:no_secret_and_account) { LibertyReserveLink::Credential.new(nil, nil, "name").valid? }

    it "returns true if all fields present" do
      expect(valid_credential).to eq true
    end

    it "returns false is no name" do
      expect(no_name).to eq false
    end

    it "returns false is no secret" do
      expect(no_secret).to eq false
    end

    it "returns false is no secret and account" do
      expect(no_secret_and_account).to eq false
    end
  end
end