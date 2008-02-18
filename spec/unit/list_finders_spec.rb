require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module QBFC::Test
  class ListFind < QBFC::List
    def self.qb_name
      "Account"
    end
  end
end

describe QBFC::List do

  before(:each) do 
    @sess = mock(QBFC::Session)
    @ole_wrapper = mock(QBFC::OLEWrapper)
    @list = QBFC::Test::List.new(@sess, @ole_wrapper)

    # Request related mocks
    @request = mock("QBFC::Request")
    @list_query = mock("QBFC::OLEWrapper#list_query")
    @response = mock("QBFC::Request#response")
  end
  
  def setup_request
    QBFC::Request.should_receive(:new).with(@sess, 'AccountQuery').and_return(@request)
    @request.should_receive(:kind_of?).with(QBFC::Request).and_return(true)
    @request.should_receive(:response).and_return(@response)
    @response.stub!(:GetAt).with(0).and_return(@ole_wrapper)
    @response.stub!(:ole_methods).and_return(["GetAt"])
  end

  describe ".find" do
    it "should find_by_name_or_id if the first argument is neither :all nor :first"
    it "should return only first entry if first argument is :first"
    it "should set request#max_returned to 1 if :first"
    it "should return an array if first argument is :all"
    it "should return nil if no elements are found unless finding :all"
    it "should return an empty array if no elements are found when finding :all"
    it "can accept a Request object"
    it "generates a Request object if not given one"
    it "accepts conditions"
    it "passes additional arguments to Request"
    it "should get request#response"
    
    describe ".find(for base_class Lists)" do 
      it "should request only ListID"
      it "should send class ChildList::find_by_id with ListID and find options for each"
    end  
  end
  
  describe ".find_by_name" do    
    before(:each) do 
      @full_name_list = mock("QBFC::OLEWrapper#full_name_list")
    end
    
    def setup_request
      super
      @request.should_receive(:ORAccountListQuery).and_return(@list_query)
      @list_query.should_receive(:FullNameList).and_return(@full_name_list)
      @full_name_list.should_receive(:Add).with("Bob Customer")
    end
    
    it "should set up Request, specifying FullNameList" do
      setup_request
      QBFC::Test::ListFind.find_by_name(@sess, "Bob Customer")
    end
  
    it "should return a List object" do
      setup_request
      list = QBFC::Test::ListFind.find_by_name(@sess, "Bob Customer")
      list.should be_kind_of(QBFC::Test::ListFind)
    end
  
    it "should return nil if none found" do
      setup_request
      @response.should_receive(:GetAt).with(0).and_return(nil)
      QBFC::Test::ListFind.find_by_name(@sess, "Bob Customer").should be_nil
    end
    
    it "should alias as find_by_full_name" do
      setup_request
      QBFC::Test::ListFind.find_by_full_name(@sess, "Bob Customer")
    end
  end
  
  describe ".find_by_id" do
    before(:each) do 
      @list_id_list = mock("QBFC::OLEWrapper#list_id_list")
    end
    
    def setup_request
      super
      @request.should_receive(:ORAccountListQuery).and_return(@list_query)
      @list_query.should_receive(:ListIDList).and_return(@list_id_list)
      @list_id_list.should_receive(:Add).with("{123-456}")
    end
    
    it "should set up Request, specifying ListIDList" do
      setup_request
      QBFC::Test::ListFind.find_by_id(@sess, "{123-456}")
    end
  
    it "should return a List object" do
      setup_request
      list = QBFC::Test::ListFind.find_by_id(@sess, "{123-456}")
      list.should be_kind_of(QBFC::Test::ListFind)
    end
  
    it "should return nil if none found" do
      setup_request
      @response.should_receive(:GetAt).with(0).and_return(nil)
      QBFC::Test::ListFind.find_by_id(@sess, "{123-456}").should be_nil
    end
  end
  
  describe ".find_by_name_or_id" do
    it "should try to find_by_id"
    it "should try to find_by_name if id fails"
    it "should return nil if both name and id return nil"
  end
end