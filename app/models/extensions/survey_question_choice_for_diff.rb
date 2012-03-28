module Extensions
  module SurveyQuestionChoiceForDiff   
      extend ActiveSupport::Concern
  
      module InstanceMethods
        def for_diff(depth=2)
          if child_questions.empty?
            %{#{'  ' * depth}* #{label}}
          else
            %{#{'  ' * depth}* #{label}\n\n} +
            child_questions.collect {|q| q.for_diff(depth+2)}.join("\n")
          end
        end
    end
  end
end

