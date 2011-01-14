require('test_helper')

class GaCookieParserTest < Test::Unit::TestCase
  include GaCookieParser
  
  def setup
    @utmz = "12979384.1294887021.1.2.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=test terms"
    @utma = "12979384.1392679796.1289844797.1294798990.1294866800.4"
  end


  context "calling the constructor with no arguments" do
    setup do
      @result = GaCookieParser.new
    end
    
    should "result in nil values for utmz and utma" do
      assert_nil @result.utma
      assert_nil @result.utmz
    end
  end
  
  context "creating a parser with a hash of raw cookie values" do
    setup do
      @result = GaCookieParser.new(:utmz => @utmz, :utma => @utma)
    end
    
    should "provide access to the raw values through utmz and utma" do
      assert !@result.utmz.nil?
      assert_equal @utma, @result.utma
      assert_equal @utmz, @result.utmz
    end
    
    should "provide access to the parsed cookie hashes through utmz_hash and utma_hash" do
      assert_not_nil @result.utmz_hash
      assert_not_nil @result.utma_hash
    end
    
    should "accurately parse the utmz cookie" do
      @p = @result.utmz_hash
      assert_equal '12979384', @p[:domain_hash]
      assert_equal '1294887021', @p[:timestamp]
      assert_equal '1', @p[:session_counter]
      assert_equal '2', @p[:campaign_number]
      assert_equal 'google', @p[:utmcsr]
      assert_equal '(organic)', @p[:utmccn]
      assert_equal 'organic', @p[:utmcmd]
      assert_equal 'test terms', @p[:utmctr]
      assert_nil @p[:utmcct]
      assert_nil @p[:utmgclid]
    end
    
    should "accurately parse the utma cookie" do
      @p = @result.utma_hash
      assert_equal '12979384', @p[:domain_hash]
      assert_equal '1392679796', @p[:visitor_id]
      assert_equal '1289844797', @p[:initial_visit_at]
      assert_equal '1294798990', @p[:previous_visit_at]
      assert_equal '1294866800', @p[:current_visit_at]
      assert_equal '4', @p[:session_counter]
    end
    
  end
  
  context "creating a parser with some cookie values missing" do
    setup do
      @missing_utmz = GaCookieParser.new(:utma => @utma)
      @missing_utma = GaCookieParser.new(:utmz => @utmz)
    end
    
    should "return nil for the parsed hashes of those cookies" do
      assert_nil  @missing_utmz.utmz_hash
      assert_nil  @missing_utma.utma_hash
    end
    
    should "indicate the values are not present" do
      assert !@missing_utmz.utmz?
      assert  @missing_utmz.utma?
      
      assert !@missing_utma.utma?
      assert @missing_utma.utmz?
    end
  end
  
  context "parsing an adwords-linked cookie" do
    setup do
      @search = GaCookieParser.new(:utmz => "57979384.1294829655.1.1.utmgclid=CL_EqKvAtKYCFU80pAodyGj_IA|utmccn=(not set)|utmcmd=(not set)|utmctr=lolcats")
      @content_network = GaCookieParser.new(:utmz => "23979724.1294828059.1.1.utmgclid=CI7wh8C6tKYCFU2DpAod7z97IQ|utmccn=(not set)|utmcmd=(not set)")
    end
      
    should "record the gclid" do
      assert_equal "CL_EqKvAtKYCFU80pAodyGj_IA", @search.utmz_hash[:utmgclid]
      assert_equal "CI7wh8C6tKYCFU2DpAod7z97IQ", @content_network.utmz_hash[:utmgclid]
    end
    
    should "set the utmcsr to 'google' and utmcmd to 'cpc'" do
      assert_equal "google", @search.utmz_hash[:utmcsr]
      assert_equal "cpc", @search.utmz_hash[:utmcmd]
      assert_equal "google", @content_network.utmz_hash[:utmcsr]
      assert_equal "cpc", @content_network.utmz_hash[:utmcmd]
    end


  end
  
  context "parsing a bad cookie" do
    setup do
      @result = GaCookieParser.new(:utmz => "123XXX", :utma => "\"jk.,./l;o.mnhhlk")
    end
      
    should "not throw an error" do
      assert @result
    end
  end
  
  
end