#! /usr/bin/env ruby
# coding: utf-8

# Author: UTUMI Hirosi (utuhiro78 at yahoo dot co dot jp)
# License: Apache License, Version 2.0

require 'nkf'
require 'open-uri'

# mecab-user-dict-seed を取得
url = "https://github.com/neologd/mecab-ipadic-neologd/tree/master/seed"
neologdver = URI.open(url).read.split("mecab-user-dict-seed.")[1]
neologdver = neologdver.split(".csv.xz")[0]

`wget -nc https://github.com/neologd/mecab-ipadic-neologd/raw/master/seed/mecab-user-dict-seed.#{neologdver}.csv.xz`
`7z x -aos mecab-user-dict-seed.#{neologdver}.csv.xz`

filename = "mecab-user-dict-seed." + neologdver + ".csv"
dicname = "mozcdic-ut-neologd.txt"

# Mozc の一般名詞のID
id_mozc = "1847"

# mecab-user-dict-seed を読み込む
file = File.new(filename, "r")
	lines = file.read.split("\n")
file.close

l2 = []
p = 0

# neologd エントリの例
# 表層形,左文脈ID,右文脈ID,コスト,品詞1,品詞2,品詞3,品詞4,品詞5,品詞6,原形,読み,発音
# little glee monster,1289,1289,2098,名詞,固有名詞,人名,一般,*,*,Little Glee Monster,リトルグリーモンスター,リトルグリーモンスター
# リトルグリーモンスター,1288,1288,-1677,名詞,固有名詞,一般,*,*,*,Little Glee Monster,リトルグリーモンスター,リトルグリーモンスター

# neologd エントリから読みと表記を取得
lines.length.times do |i|
	s = lines[i].split(",")

	# 「読み」を読みにする
	yomi = s[11]

	# 「原形」を表記にする
	hyouki = s[10]

	# 読みが2文字以下の場合はスキップ
	if yomi[2] == nil ||
	# 表記が1文字の場合はスキップ
	hyouki[1] == nil ||
	# 表記が26文字以上の場合はスキップ。候補ウィンドウが大きくなりすぎる
	hyouki[25] != nil
		next
	end

	# 読みのカタカナをひらがなに変換
	yomi = NKF.nkf("--hiragana -w -W", yomi)
	yomi = yomi.tr("ゐゑ", "いえ")

	# 読みがひらがな以外を含む場合はスキップ
	if yomi != yomi.scan(/[ぁ-ゔー]/).join
		next
	end

	# 名詞以外の場合はスキップ
	if s[4] != "名詞" ||
	# 「地域」をスキップ。地名は郵便番号ファイルから生成する
	s[6] == "地域" ||
	# 「名」をスキップ
	s[7] == "名"
		next
	end

	# [読み, 表記, コスト] の順に並べる
	l2[p] = [yomi, hyouki, s[3].to_i]
	p = p + 1
end

lines = l2.sort
l2 = []

# Mozc 形式で書き出す
dicfile = File.new(dicname, "w")

lines.length.times do |i|
	s1 = lines[i]
	s2 = lines[i - 1]

	# 他の [読み..表記] と重複するエントリをスキップ
	if s1[0..1] == s2[0..1]
		next
	end

	# コストが 0 未満なら 0 にする
	if s1[2] < 0
		s1[2] = 0
	end

	# コストが 10000 以上なら 9999 にする 
	if s1[2] > 9999
		s1[2] = 9999
	end

	# 全体のコストを 8000 台にする
	s1[2] = 8000 + (s1[2] / 10)

	# [読み, id_mozc, id_mozc, コスト, 表記] の順に並べる
	t = [s1[0], id_mozc, id_mozc, s1[2].to_s, s1[1]]
	dicfile.puts t.join("	")
end

dicfile.close
