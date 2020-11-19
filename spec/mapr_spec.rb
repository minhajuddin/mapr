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

    it "simple array finders" do
      user = Mapr.map(<<~SCHEMA, {"User" => {"Ids" => [3, 4], "Name" => {"FirstName" => "Danny", "LastName" => "K"}}})
      :id: User/Ids/0
      :first_name: User/Name/FirstName
      :last_name: User/Name/LastName
      SCHEMA
      expect(user).to eq(id: 3, first_name: "Danny", last_name: "K")
    end

    it "simple array finders with data array" do
      user = Mapr.map(<<~SCHEMA, [3, 4])
      :id: 0
      :second_id: 1
      SCHEMA
      expect(user).to eq(id: 3, second_id: 4)
    end

    it "complex array finders" do
      user = Mapr.map(<<~SCHEMA, {"Users" => [{"Name" => "Danny"}, {"Name" => "Mujju"}]})
      :user_1_name: Users/0/Name
      :user_2_name: Users/1/Name
      SCHEMA
      expect(user).to eq(user_1_name: "Danny", user_2_name: "Mujju")
    end

    it "throws an error for invalid paths" do
      expect {
        Mapr.map(<<~SCHEMA, [3, 4])
        :id: 0.3
        SCHEMA
      }.to raise_error(Mapr::Error, /Path has to be a string or integer path was of type: 'Float'/)
    end
  end
end
