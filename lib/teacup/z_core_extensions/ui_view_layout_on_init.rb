module LayoutMacros
  attr_reader :layout_definition

  def layout(stylename=nil, properties={}, &block)
    @layout_definition = [stylename, properties, block]
  end

  def stylesheet(new_stylesheet=nil)
    if new_stylesheet.nil?
      return @stylesheet
    end

    @stylesheet = new_stylesheet
  end
end

module LayoutOnInit
  def self.included(base)
    base.class_exec do
      alias :old_init :init

      def init
        old_init

        if not self.stylesheet
          self.stylesheet = self.class.stylesheet
        end

        if self.class.layout_definition
          stylename, properties, block = self.class.layout_definition
          layout(self, stylename, properties, &block)
        end

        self
      end

      class << self
        include LayoutMacros
      end
    end
  end
end

class UIView
  include LayoutOnInit
end
