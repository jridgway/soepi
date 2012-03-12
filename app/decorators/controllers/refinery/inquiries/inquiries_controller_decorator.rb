Refinery::Inquiries::InquiriesController.class_eval do 
  layout Proc.new { |controller| controller.request.xhr? ? 'ajax' : 'one_column' }
end