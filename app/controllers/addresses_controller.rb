class AddressesController < ApplicationController
  layout nil

  def states_for_country
    if params[:country].blank?
      render :nothing => true
    else
      @states = Country.new(params[:country]).states.
        collect {|s| s.last['name']}.
        sort {|a,b| a <=> b}.
        collect {|s| s.force_encoding('UTF-8')}
    end
  end
  
  def cities_for_country_and_state_autocomplete
    stusab = state_name_to_abbr(params[:current_state])
    render :text => CensusGeo.select('name').
      where('name ilike ? and stusab = ?', "#{params[:term]}%", stusab).group('name').limit(10).collect(&:name).to_json.html_safe
  end
  
  protected
    
    def state_name_to_abbr(name)
      names = {
        :'alaska' => 'AK',
        :'alabama' => 'AL',
        :'arkansas' => 'AR',
        :'american samoa' => 'AS',
        :'arizona' => 'AZ',
        :'california' => 'CA',
        :'colorado' => 'CO',
        :'connecticut' => 'CT',
        :'district of columbia' => 'DC',
        :'delaware' => 'DE',
        :'florida' => 'FL',
        :'georgia' => 'GA',
        :'guam' => 'GU',
        :'hawaii' => 'HI',
        :'iowa' => 'IA',
        :'idaho' => 'ID',
        :'illinois' => 'IL',
        :'indiana' => 'IN',
        :'kansas' => 'KS',
        :'kentucky' => 'KY',
        :'louisiana' => 'LA',
        :'massachusetts' => 'MA',
        :'maryland' => 'MD',
        :'maine' => 'ME',
        :'michigan' => 'MI',
        :'minnesota' => 'MN',
        :'missouri' => 'MO',
        :'northern mariana islands' => 'MP',
        :'mississippi' => 'MS',
        :'montana' => 'MT',
        :'north carolina' => 'NC',
        :'north dakota' => 'ND',
        :'nebraska' => 'NE',
        :'new hampshire' => 'NH',
        :'new jersey' => 'NJ',
        :'new mexico' => 'NM',
        :'nevada' => 'NV',
        :'new york' => 'NY',
        :'ohio' => 'OH',
        :'oklahoma' => 'OK',
        :'oregon' => 'OR',
        :'pennsylvania' => 'PA',
        :'puerto rico' => 'PR',
        :'rhode island' => 'RI',
        :'south carolina' => 'SC',
        :'south dakota' => 'SD',
        :'tennessee' => 'TN',
        :'texas' => 'TX',
        :'united states minor outlying islands' => 'UM',
        :'utah' => 'UT',
        :'virginia' => 'VA',
        :'virgin islands, u.s.' => 'VI',
        :'vermont' => 'VT',
        :'washington' => 'WA',
        :'wisconsin' => 'WI',
        :'west virginia' => 'WV',
        :'wyoming' => 'WY'
      }
      names[name.to_sym.downcase.to_sym]
    end
end
