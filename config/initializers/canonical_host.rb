unless Rails.env.development?
  Rails.application.config.middleware.insert_before Rack::SSL, Rack::CanonicalHost do
    case ENV['RACK_ENV'].to_sym
      when :production then 'secure.soepi.org'
    end
  end
end