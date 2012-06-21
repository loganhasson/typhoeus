require 'spec_helper'

describe Typhoeus::Requests::Marshal do
  let(:url) { "localhost:3001" }
  let(:request) { Typhoeus::Request.new(url) }

  describe "#marshal_dump" do
    let(:url) { "http://www.google.com" }

    ['on_complete'].each do |name|
      context "when #{name} handler" do
        before { request.instance_variable_set("@#{name}", Proc.new{}) }

        it "doesn't include @#{name}" do
          request.send(:marshal_dump).map(&:first).should_not include("@#{name}")
        end

        it "doesn't raise when dumped" do
          expect { Marshal.dump(request) }.to_not raise_error
        end

        context "when loading" do
          let(:loaded) { Marshal.load(Marshal.dump(request)) }

          it "includes url" do
            loaded.url.should eq(request.url)
          end

          it "doesn't include #{name}" do
            loaded.send(name).should be_nil
          end
        end
      end
    end
  end
end