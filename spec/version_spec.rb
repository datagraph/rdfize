require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'RDFize::VERSION' do
  it "matches the VERSION file" do
    RDFize::VERSION.to_s.should == File.read(File.join(File.dirname(__FILE__), '..', 'VERSION')).chomp
  end
end
