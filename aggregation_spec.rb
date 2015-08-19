require 'spec_helper'

describe Aggregation do
  class User
    include Mongoid::Document
  end

  let(:criteria) { User.all }

  it 'can be initialize with a Mongoid Criteria' do
    expect(Aggregation.new(criteria)).to be
  end

  it 'can be initialized with a Model' do
    expect(Aggregation.new(User)).to be
  end

  it 'cannot be initialize with a class that does not include Mongoid::Criteria' do
    expect { Aggregation.new(Array) }.to raise_error ArgumentError, "must be a criteria or class with Mongoid::Document"
  end

  context 'when given a object with selector' do
    it 'adds selector as the matcher' do
      aggregation = Aggregation.new(criteria.where(email: 'test@example.com'))
      expect(aggregation.pipeline).to match_array([{ '$match' => { 'email' => 'test@example.com' } }])
    end
  end

  describe '#q!' do
    it 'executes the aggregation' do
      expect(aggregation.limit(1).q!).to be_a []
    end
  end
end