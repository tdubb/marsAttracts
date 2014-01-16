require "spec_helper"

describe Passenger do
  describe "pass_confirm" do
    let(:mail) { Passenger.pass_confirm }

    it "renders the headers" do
      mail.subject.should eq("Pass confirm")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
