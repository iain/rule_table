require "ostruct"

RuleTable.matcher :os do |pattern|
  pattern === os
end

RuleTable.matcher :width do |pattern|
  pattern === resolution.width
end

RuleTable.matcher :height do |pattern|
  pattern === resolution.height
end

RuleTable.matcher :misc do |pattern|
  pattern === user_agent_misc
end

TABLE = RuleTable.new do

  rule :ios_hi, match(:os,     /ios/i),
                match(:width,  1024..2732),
                match(:height, 768..2048)

  rule :ios_lo, match(:os,     /ios/i),
                match(:width,  0...1024),
                match(:height, 0...768)

  rule :ereader, match(:os,    /android/i),
                 match(:misc,  /inky/i)

  # more rules omitted

  rule :unknown

end

RSpec.describe RuleTable do

  it "finds the first complete match" do
    device = OpenStruct.new(
      os: "iOS",
      resolution: OpenStruct.new(
        width: 700,
        height: 400,
      ),
      user_agent_misc: "(Inky)",
    )

    expect(TABLE.match(device)).to eq :ios_lo
  end

  it "might not find any" do
    device = OpenStruct.new(
      os: "Android",
      resolution: OpenStruct.new(
        width: 1430,
        height: 1080
      ),
      user_agent_misc: "Nexus 6",
    )

    expect(TABLE.match(device)).to eq :unknown
  end

end
