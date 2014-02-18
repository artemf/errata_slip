# encoding: UTF-8

require 'spec_helper'

describe ErrataSlip do

  context '.correct_item!' do

    tests =
        [
            {
                it: 'should not correct when errata doesn' 't match',
                errata: [{ 'name' => 'Adam', '~name' => 'Brian' }],
                item: { 'name' => 'NoSuchName' },
                expected: { 'name' => 'NoSuchName' }
            },
            {
                it: 'should change fields',
                errata: [{ 'name' => 'Adam', '~name' => 'Brian' }],
                item: { 'name' => 'Adam' },
                expected: { 'name' => 'Brian' }
            },
            {
                it: 'should leave unmentioned fields intact',
                errata: [{ 'name' => 'Adam', '~name' => 'Brian' }],
                item: { 'name' => 'Adam', 'surname' => 'Other' },
                expected: { 'name' => 'Brian', 'surname' => 'Other' }
            },
            {
                it: 'should add new fields',
                errata: [{ 'name' => 'Adam', '~country' => 'Honduras' }],
                item: { 'name' => 'Adam' },
                expected: { 'name' => 'Adam', 'country' => 'Honduras' }
            },
            {
                it: 'should change (symbolic) fields',
                errata: [{ 'name' => 'Adam', '~name' => 'Brian' }],
                item: { :name => 'Adam' },
                expected: { :name => 'Brian' }
            },
            {
                it: 'should add new (symbolic) fields',
                errata: [{ 'name' => 'Adam', '~country' => 'Honduras' }],
                item: { :name => 'Adam' },
                expected: { :name => 'Adam', :country => 'Honduras' }
            },
            {
                it: 'should match multiple fields',
                errata: [{ 'name' => 'Adam', 'surname' => 'Smith', '~name' => 'Brian' }],
                item: { 'name' => 'Adam', 'surname' => 'Smith' },
                expected: { 'name' => 'Brian', 'surname' => 'Smith' }
            },
            {
                it: 'should not match partial multiple fields matches',
                errata: [{ 'name' => 'Adam', 'surname' => 'Smith', '~name' => 'Brian' }],
                item: { 'name' => 'Adam', 'surname' => 'Klien' },
                expected: { 'name' => 'Adam', 'surname' => 'Klien' }
            }

    ]

    tests.each do |test|
      it test[:it] do
        ErrataSlip.new(test[:errata]).correct_item!(test[:item])
        test[:item].should eq test[:expected]
      end
    end

    it 'should return the modified item too' do
      errata = [ { 'name' => 'Adam', '~name' => 'Brian' } ]
      item = { 'name' => 'Adam' }
      expected = { 'name' => 'Brian' }
      result = ErrataSlip.new(errata).correct_item!(item)
      result.should eq expected
      item.should eq expected
      result.should eq item
    end

  end

  context '.correct!' do
    let(:errata) { [{ 'name' => 'Adam', '~name' => 'Brian' }, { 'name' => 'Arthur', '~name' => 'Bob' }] }
    let(:input) { [{ 'name' => 'Adam' }, { 'name' => 'Arthur' }] }
    let(:expected) { [{ 'name' => 'Brian' }, { 'name' => 'Bob' }] }

    it 'should change fields' do
      ErrataSlip.new(errata).correct!(input)
      input.should eq expected
    end

    let(:input) { [{ 'name' => 'Adam' }, { 'name' => 'Arthur' }, { 'name' => 'Alex' }] }
    let(:expected) { [{ 'name' => 'Brian' }, { 'name' => 'Bob' }, { 'name' => 'Alex' }] }

    it 'should change fields, except when errata doesn' 't match' do
      ErrataSlip.new(errata).correct!(input)
      input.should eq expected
    end

    let(:errata) { [{ 'name' => 'Adam', '~country' => 'Honduras' }, { 'name' => 'Arthur', '~country' => 'Guatemala' }] }
    let(:expected) { [{ 'name' => 'Adam', 'country' => 'Honduras' }, { 'name' => 'Arthur', 'country' => 'Guatemala' }, { 'name' => 'Alex' }] }

    it 'should add new fields, except when errata doesn' 't match' do
      ErrataSlip.new(errata).correct!(input)
      input.should eq expected
    end

    let(:errata) { [{ 'name' => 'Adam', '~name' => 'Brian' }, { 'name' => 'Arthur', '~country' => 'Guatemala' }] }
    let(:expected) { [{ 'name' => 'Brian' }, { 'name' => 'Arthur', 'country' => 'Guatemala' }, { 'name' => 'Alex' }] }

    it 'should both change fields and add new fields' do
      ErrataSlip.new(errata).correct!(input)
      input.should eq expected
    end

  end

  context '::load_file' do
    it 'should load errata from file' do
      expected_errata = [{ 'name' => 'Adam', '~name' => 'Brian' }, { 'name' => 'Arthur', '~name' => 'Bob' }]
      slip = ErrataSlip::load_file(File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', 'errata.yaml')))
      slip.errata.should eq expected_errata
    end
  end
end