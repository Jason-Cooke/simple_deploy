require 'spec_helper'

describe SimpleDeploy::Misc::AttributeMerger do
  include_context 'stubbed config'

  before do
    @mapper_mock = mock 'mapper'

    @stacks  = ['stack1', 'stack2']
    @options = { :environment  => 'default',
                 :attributes   => [ { 'attrib1' => 'val1' } ],
                 :input_stacks => @stacks,
                 :template     => '/tmp/file.json' }
    SimpleDeploy::Stack::OutputMapper.should_receive(:new).
                                    with(:environment => @options[:environment]).
                                    and_return @mapper_mock
    @merger = SimpleDeploy::Misc::AttributeMerger.new
  end

  it "should return the consolidated list of attributes" do
    @mapper_mock.should_receive(:map_outputs_from_stacks).
                 with(:stacks   => @options[:input_stacks],
                      :template => @options[:template]).
                 and_return [ { 'attrib2' => 'val2' } ]
    @merger.merge(@options).should == [ { 'attrib1' => 'val1' },
                                        { 'attrib2' => 'val2' } ]
  end

  it "should return provided attributes over outputs" do
    @mapper_mock.should_receive(:map_outputs_from_stacks).
                 with(:stacks   => @options[:input_stacks],
                      :template => @options[:template]).
                 and_return [ { 'attrib1' => 'val2' } ]
    @merger.merge(@options).should == [ { 'attrib1' => 'val1' } ]
  end
end
