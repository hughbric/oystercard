require 'oystercard'

describe Oystercard do
  it 'responds to balance' do
    expect(subject).to respond_to(:balance)
  end

  describe '#top_up' do
    it 'allows customer to top up' do
      expect(subject).to respond_to(:top_up).with(1).argument
    end

    it 'raises an error when topping up over the limit' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      expect{ subject.top_up(1) }.to raise_error "Top-up Limit Reached."
    end
  end

  describe 'tap functionality' do
    subject { Oystercard.new(5) }

    it 'is initially not in a journey' do
      expect(subject).not_to be_in_journey
    end

    it 'allows customer to tap-in' do
      expect(subject.touch_in).to be true
    end

    it 'allows customer to tap-out' do
      expect(subject.touch_out).to be false
    end

    it 'checks if card is in use' do
      subject.touch_in
      expect(subject).to be_in_journey
    end

    it 'checks if tap-out ends journey' do
      subject.touch_in
      subject.touch_out
      expect(subject).not_to be_in_journey
    end
  end

  describe 'balance checks' do
    it 'raises error if tapping-in when balance is < £1' do
      expect { subject.touch_in }.to raise_error "Insufficient funds."
    end

    it 'balance is reduced when tapping out' do
      balance_reduced = -Oystercard::MINUMUM_FARE
      expect { subject.touch_out }.to change{ subject.balance }.by(balance_reduced)
    end
  end

  describe 'journey details' do
    it 'stores starting station' do
      subject.top_up(20)
      station = "Aldgate East"
      expect(subject).to respond_to(:touch_in).with(1).argument
    end
  end
end
