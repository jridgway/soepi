module SimpleForm
  module Inputs
    class DatetimePickerInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options.merge(datetimepicker_options(object.send(attribute_name))))
      end

      def datetimepicker_options(value = nil)
        datetimepicker_options = {:value => value.nil?? nil : I18n.localize(value)}
      end
    end

    class DatePickerInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options.merge(datepicker_options(object.send(attribute_name))))
      end

      def datepicker_options(value = nil)
        datepicker_options = {:value => value.nil?? nil : I18n.localize(value)}
      end
    end

    class TimePickerInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options.merge(timepicker_options(object.send(attribute_name))))
      end

      def timepicker_options(value = nil)
        timepicker_options = {:value => value.nil?? nil : I18n.localize(value)}
      end
    end
  end
end
