module GaCookieParser
  
  def self.parse(*args)
    GaCookieParser.new(*args)
  end
  
  
  class GaCookieParser
    
    attr_reader :utmz, :utmb, :utma, :utmz_hash, :utmb_hash, :utma_hash
    
    def initialize(cookies = {})
      @utmz = cookies[:utmz]
      @utmb = cookies[:utmb]
      @utma = cookies[:utma]
      parse_cookies
    end
    
    def utmz?
      !(@utmz.nil? || @utmz.empty?)
    end
    
    def utmb?
      !(@utmb.nil? || @utmb.empty?)
    end
    
    def utma?
      !(@utma.nil? || @utma.empty?)
    end
    
    def parse_cookies
      parse_utmz
      parse_utmb
      parse_utma
    end
    
    def parse_utmz
       return if (@utmz.nil? || @utmz.empty?)
       @utmz_hash = h = {}
       h[:domain_hash], h[:timestamp], h[:session_counter], h[:campaign_number], kv_pairs = @utmz.split(".", 5)
       
       kv_pairs && kv_pairs.split("|").each do |pair|
         k, v = pair.split("=")
         h[k.to_sym] = v if k && v
       end
       
       if h[:utmgclid]
         h[:utmcsr] = 'google'
         h[:utmcmd] = 'cpc'
       end
       
    end
    
    def parse_utmb
      return if (@utmb.nil? || @utmb.empty?)
      @utmb_hash = h = {}
      h[:domain_hash], h[:pageview], h[:outbound_click], h[:timestamp] = @utmb.split(".")
    end
    
    def parse_utma
      return if (@utma.nil? || @utma.empty?)
      @utma_hash = h = {}
      h[:domain_hash], h[:visitor_id], h[:initial_visit_at], h[:previous_visit_at], h[:current_visit_at], h[:session_counter] = @utma.split(".")
    end
    
  end
  
  
end
