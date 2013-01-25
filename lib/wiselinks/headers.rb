module Wiselinks
  module Headers    
    
    def self.included(base)      
      base.helper_method :wiselinks_title
    end

  protected

    def wiselinks_layout
      'wiselinks'
    end

    def render(options = {}, *args, &block)
      if self.request.wiselinks?        
        response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
        response.headers['Pragma'] = 'no-cache'

        if self.request.wiselinks_partial?
          Wiselinks.log("processing partial request")
          options[:partial] ||= action_name
        else
          Wiselinks.log("processing template request")
          
          if Wiselinks.options[:layout] != false
            options[:layout] = self.wiselinks_layout 
          end
        end

        if Wiselinks.options[:assets_digest].present?
          Wiselinks.log("assets digest #{Wiselinks.options[:assets_digest]}")

          self.headers['X-Assets-Digest'] = Wiselinks.options[:assets_digest]          
        end
      end

      super
    end

    def wiselinks_title(value)
      if self.request.wiselinks? && value.present?
        Wiselinks.log("title: #{value}")        
        response.headers['X-Title'] = URI.encode(value)
      end
    end    

    def wiselinks_request?
      Wiselinks::Logger.log "DEPRECATION WARNING: Method `wiselinks_request?` is deprecated. Please use `request.wiselinks?` instead."

      self.request.wiselinks?
    end

    def wiselinks_template_request?
      Wiselinks::Logger.log "DEPRECATION WARNING: Method `wiselinks_template_request?` is deprecated. Please use `request.wiselinks_template?` instead."

      self.request.wiselinks_template?
    end

    def wiselinks_partial_request?
      Wiselinks::Logger.log "DEPRECATION WARNING: Method `wiselinks_partial_request?` is deprecated. Please use `request.wiselinks_partial?` instead."

      self.request.wiselinks_partial?
    end
  end
end