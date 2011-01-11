require 'sinatra'
require 'snmp'
require 'erubis'
require 'json'


class SNMPPlot < Sinatra::Base
  include SNMP

  enable :static
  set :public, File.dirname( __FILE__ ) + '/public'

  get '/s' do
    host = params[:host]
    path = params[:path]
    values = nil
    oidlist = []
    path.each do |p|
      oidlist << ObjectId.new(p)
    end
    SNMP::Manager.open(:Host => host) do |snmp|
          values = snmp.get_value(oidlist)
    end
    puts "VV #{values.to_json}"
    return values.to_json if values
  end

  get '/' do
    erubis :index
  end


end
