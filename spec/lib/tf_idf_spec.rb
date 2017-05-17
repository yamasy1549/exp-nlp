require 'tf_idf'

describe "tf_idf" do
  it "tfの計算" do
    expect(tf(1, 10)).to eq(Rational(1, 10))
  end

  it "idfの計算" do
    expect(idf(2, 1)).to eq(2)
  end

  it "tf_idfの計算" do
    expect(tf_idf(1, 10, 2, 1)).to eq(0.2)
  end
end
