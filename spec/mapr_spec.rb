RSpec.describe Mapr do
  it "has a version number" do
    expect(Mapr::VERSION).not_to be nil
  end

  it "maps simple objects" do
    user = Mapr.map(<<~SCHEMA, {"FirstName" => "Danny", "LastName" => "K"})
    :first_name: "FirstName"
    :last_name: "LastName"
    SCHEMA
    expect(user).to eq(first_name: "Danny", last_name: "K")
  end
end
