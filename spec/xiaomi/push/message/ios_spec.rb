require 'spec_helper'

describe Xiaomi::Push::Message::IOS do

  context 'title' do
    it 'has not default value' do
      expect(subject.title).to be_nil
    end

    it 'should equal given value' do
      title = 'this is title'
      subject.title = title
      expect(subject.title).to eq title
    end
  end

  context 'description' do
    it 'has not default value' do
      expect(subject.description).to be_nil
    end

    it 'should equal given value' do
      description = 'this is description'
      subject.description = description
      expect(subject.description).to eq description
    end
  end

  context 'badge' do
    it 'has a default value is 1' do
      expect(subject.badge).to eq 1
    end

    it 'should equal given value' do
      badge = 3
      subject.badge = badge
      expect(subject.badge).to eq badge
    end
  end

  context 'category' do
    it 'has a default empty hash' do
      expect(subject.category).to be_nil
    end

    it 'should equal given value' do
      category = 'DELETE_EVENT'
      subject.category = category
      expect(subject.category).to eq category
    end
  end

  context 'extras' do
    it 'has a default empty hash' do
      expect(subject.extras).to be_kind_of Hash
    end

    it 'should equal given value' do
      badge = 3
      subject.badge = badge
      expect(subject.badge).to eq badge
    end
  end

  describe 'initialize' do
    let(:message) { Xiaomi::Push::Message::IOS.new(title: 'TBFP', description:'Today before friday party')}
    it 'should has valid value for title and desc' do
      expect(message.title).to eq 'TBFP'
      expect(message.description).to eq 'Today before friday party'
    end
  end

end
