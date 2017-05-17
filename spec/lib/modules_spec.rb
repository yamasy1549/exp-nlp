require 'modules'

describe "modules" do
  describe "Array" do
    using ArrayEx

    it "ngramに分割して配列を返す" do
      array = %W(a b c d e)
      expect(array.ngram(2)).to eq(%W(ab bc cd de))
    end
  end

  describe "Hash" do
    using HashEx

    it "単語の出現回数を集計する" do
      hash = { "し" => { "0.txt" => 1 } }
      ngram = %W(か か し)
      file_name = "1.txt"
      expect(hash.collect_words(ngram, file_name)).to eql({ "か" => { "1.txt" => 2 }, "し" => { "0.txt" => 1, "1.txt" => 1 } })
    end

    it "valueが最大の組を配列で返す" do
      hash = { "0.txt" => 1, "1.txt" => 2, "2.txt" => 0 }
      expect(hash.max_value).to eql(2)
    end

    it "valueが最小の組を配列で返す" do
      hash = { "0.txt" => 1, "1.txt" => 2, "2.txt" => 0 }
      expect(hash.min_value).to eql(0)
    end
  end

  describe "String" do
    using StringEx

    before(:all) do
      @string1 = "かかしのように棒立ちしてしまう。"
      @string2 = "ひなこのーと http://hinakonote.jp/ 4月7日からテレビ放送開始！"
      @string3 = ":;）「か^か'し][みた|||い｝だね。！」"
    end

    it "ngramに分割して配列を返す" do
      expect(@string1.ngram(2)).to eql(%W(かか かし しの のよ よう うに に棒 棒立 立ち ちし して てし しま まう う。))
    end

    it "分かち書きして配列を返す" do
      expect(@string1.wakati).to eq(%W(かかし の よう に 棒立ち し て しまう 。))
    end

    it "指定した品詞だけ残して分かち書きして配列を返す" do
      pos = ["名詞", "動詞"]
      expect(@string1.wakati(pos)).to eq(%W(かかし よう 棒立ち し しまう))
    end

    it "URLを削除する" do
      expect(@string2.remove_url).to eq("ひなこのーと  4月7日からテレビ放送開始！")
    end

    it "記号を削除する" do
      expect(@string3.remove_symbols).to eq("かかしみたいだね")
    end
  end
end
