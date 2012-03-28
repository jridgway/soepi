module Extensions
  module SurveyQuestionForDiff   
    extend ActiveSupport::Concern

    module InstanceMethods
      def for_diff(depth=1)
        s = %{#{'  ' * depth}== Question #{path} ==\n} +
        %{#{'  ' * depth}Body: #{wrap_text(body).gsub("\n", "\n#{'  ' * (depth+3)}").strip}\n} +
        %{#{'  ' * depth}Type: #{qtype}\n} +
        %{#{'  ' * depth}Required: #{required? ? 'Yes' : 'No'}\n}
        unless choices.empty?
          s += %{#{'  ' * depth}Choices:\n\n#{choices.collect {|q| q.for_diff(depth+1)}.join("\n")}\n\n}
        end
      end
      
      def wrap_text(s, col=80)
        s.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/, "\\1\\3\n") 
      end
    end
  end
end
