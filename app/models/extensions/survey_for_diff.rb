module Extensions
  module SurveyForDiff   
    extend ActiveSupport::Concern

    module InstanceMethods
      def for_diff
        %{Title: #{title}\n} +
        %{Description: #{wrap_text(description).gsub("\n", "\n    ").strip}\n} +
        %{Tags: #{tag_list}\n} +
        %{Purpose: #{wrap_text(purpose_of_survey).gsub("\n", "\n    ").strip}\n} +
        %{Uses of Results: #{wrap_text(uses_of_results).gsub("\n", "\n    ").strip}\n} +
        %{Questions:\n\n#{root_questions.collect(&:for_diff).join}\n}
      end
      
      def wrap_text(s, col=80)
        s.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/, "\\1\\3\n") 
      end
    end
  end
end

