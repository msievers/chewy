require 'spec_helper'

describe Chewy::Query::Criteria do
  include ClassHelpers

  subject { described_class.new }

  its(:search) { should == {} }
  its(:query) { should == {} }
  its(:facets) { should == {} }
  its(:filters) { should == [] }
  its(:sort) { should == [] }
  its(:fields) { should == [] }
  its(:types) { should == [] }

  its(:search?) { should be_false }
  its(:query?) { should be_false }
  its(:facets?) { should be_false }
  its(:filters?) { should be_false }
  its(:sort?) { should be_false }
  its(:fields?) { should be_false }
  its(:types?) { should be_false }

  describe '#update_search' do
    specify { expect { subject.update_search(field: 'hello') }.to change { subject.search? }.to(true) }
    specify { expect { subject.update_search(field: 'hello') }.to change { subject.search }.to(field: 'hello') }
  end

  describe '#update_query' do
    specify { expect { subject.update_query(field: 'hello') }.to change { subject.query? }.to(true) }
    specify { expect { subject.update_query(field: 'hello') }.to change { subject.query }.to(field: 'hello') }
  end

  describe '#update_facets' do
    specify { expect { subject.update_facets(field: 'hello') }.to change { subject.facets? }.to(true) }
    specify { expect { subject.update_facets(field: 'hello') }.to change { subject.facets }.to(field: 'hello') }
  end

  describe '#update_filters' do
    specify { expect { subject.update_filters(field: 'hello') }.to change { subject.filters? }.to(true) }
    specify { expect { subject.update_filters(field: 'hello') }.to change { subject.filters }.to([{field: 'hello'}]) }
    specify { expect { subject.update_filters(field: 'hello'); subject.update_filters(field: 'world') }
      .to change { subject.filters }.to([{field: 'hello'}, {field: 'world'}]) }
    specify { expect { subject.update_filters([{field: 'hello'}, {field: 'world'}, nil]) }
      .to change { subject.filters }.to([{field: 'hello'}, {field: 'world'}]) }
  end

  describe '#update_sort' do
    specify { expect { subject.update_sort(:field) }.to change { subject.sort? }.to(true) }

    specify { expect { subject.update_sort([:field]) }.to change { subject.sort }.to([:field]) }
    specify { expect { subject.update_sort([:field1, :field2]) }.to change { subject.sort }.to([:field1, :field2]) }
    specify { expect { subject.update_sort([{field: :asc}]) }.to change { subject.sort }.to([{field: :asc}]) }
    specify { expect { subject.update_sort([:field1, field2: {order: :asc}]) }.to change { subject.sort }.to([:field1, {field2: {order: :asc}}]) }
    specify { expect { subject.update_sort([{field1: {order: :asc}}, :field2]) }.to change { subject.sort }.to([{field1: {order: :asc}}, :field2]) }
    specify { expect { subject.update_sort([field1: :asc, field2: {order: :asc}]) }.to change { subject.sort }.to([{field1: :asc}, {field2: {order: :asc}}]) }
    specify { expect { subject.update_sort([{field1: {order: :asc}}, :field2, :field3]) }.to change { subject.sort }.to([{field1: {order: :asc}}, :field2, :field3]) }
    specify { expect { subject.update_sort([{field1: {order: :asc}}, [:field2, :field3]]) }.to change { subject.sort }.to([{field1: {order: :asc}}, :field2, :field3]) }
    specify { expect { subject.update_sort([{field1: {order: :asc}}, [:field2], :field3]) }.to change { subject.sort }.to([{field1: {order: :asc}}, :field2, :field3]) }
    specify { expect { subject.update_sort([{field1: {order: :asc}, field2: :desc}, [:field3], :field4]) }.to change { subject.sort }.to([{field1: {order: :asc}}, {field2: :desc}, :field3, :field4]) }
    specify { expect { subject.tap { |s| s.update_sort([field1: {order: :asc}, field2: :desc]) }.update_sort([[:field3], :field4]) }.to change { subject.sort }.to([{field1: {order: :asc}}, {field2: :desc}, :field3, :field4]) }
    specify { expect { subject.tap { |s| s.update_sort([field1: {order: :asc}, field2: :desc]) }.update_sort([[:field3], :field4], purge: true) }.to change { subject.sort }.to([:field3, :field4]) }
  end

  describe '#update_fields' do
    specify { expect { subject.update_fields(:field) }.to change { subject.fields? }.to(true) }
    specify { expect { subject.update_fields(:field) }.to change { subject.fields }.to(['field']) }
    specify { expect { subject.update_fields([:field, :field]) }.to change { subject.fields }.to(['field']) }
    specify { expect { subject.update_fields([:field1, :field2]) }.to change { subject.fields }.to(['field1', 'field2']) }
    specify { expect { subject.tap { |s| s.update_fields(:field1) }.update_fields([:field2, :field3]) }
      .to change { subject.fields }.to(['field1', 'field2', 'field3']) }
    specify { expect { subject.tap { |s| s.update_fields(:field1) }.update_fields([:field2, :field3], purge: true) }
      .to change { subject.fields }.to(['field2', 'field3']) }
  end

  describe '#update_types' do
    specify { expect { subject.update_types(:type) }.to change { subject.types? }.to(true) }
    specify { expect { subject.update_types(:type) }.to change { subject.types }.to(['type']) }
    specify { expect { subject.update_types([:type, :type]) }.to change { subject.types }.to(['type']) }
    specify { expect { subject.update_types([:type1, :type2]) }.to change { subject.types }.to(['type1', 'type2']) }
    specify { expect { subject.tap { |s| s.update_types(:type1) }.update_types([:type2, :type3]) }
      .to change { subject.types }.to(['type1', 'type2', 'type3']) }
    specify { expect { subject.tap { |s| s.update_types(:type1) }.update_types([:type2, :type3], purge: true) }
      .to change { subject.types }.to(['type2', 'type3']) }
  end
end