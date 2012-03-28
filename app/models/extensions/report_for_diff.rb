module Extensions
  module ReportForDiff   
    extend ActiveSupport::Concern

    module InstanceMethods
      def for_diff
        %{Title: #{title}\nTags: #{tag_list.join(', ')}\nCode:\n\n  #{code.gsub("\n", "\n  ")}\n}
      end
    end
  end
end

