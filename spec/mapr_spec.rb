RSpec.describe Mapr do
  it "has a version number" do
    expect(Mapr::VERSION).not_to be nil
  end

  describe '#map' do
    it "one level finders" do
      user = Mapr.map(<<~SCHEMA, {"FirstName" => "Danny", "LastName" => "K"})
    :first_name: "FirstName"
    :last_name: "LastName"
      SCHEMA
      expect(user).to eq(first_name: "Danny", last_name: "K")
    end

    it "2 level finders" do
      user = Mapr.map(<<~SCHEMA, {"Name" => {"FirstName" => "Danny", "LastName" => "K"}})
      :first_name: Name/FirstName
      :last_name: Name/LastName
      SCHEMA
      expect(user).to eq(first_name: "Danny", last_name: "K")
    end

    it "3 level finders" do
      user = Mapr.map(<<~SCHEMA, {"User" => {"Id" => 3, "Name" => {"FirstName" => "Danny", "LastName" => "K"}}})
      :id: User/Id
      :first_name: User/Name/FirstName
      :last_name: User/Name/LastName
      SCHEMA
      expect(user).to eq(id: 3, first_name: "Danny", last_name: "K")
    end
  end
end
