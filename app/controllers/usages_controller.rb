class UsagesController < ApplicationController
    def newest
        #@usage = Usage.all()
        #render :text => @usage[@usage.size - 1].power
        usage = Usage.where("feedId = ?", session[:current_user_id]).last
        render :text => usage.to_json
    end
    
    def newestday
        #puts Date.today.strftime('%Y%m%d')
        #puts (Date.today + 1).strftime('%Y%m%d')
        #@usage = Usage.where("timestamp >= '20170406 00:00:00' and timestamp < '20170407 00:00:00'")
        @usage = Usage.where("feedId = ? and timestamp >= ? and timestamp < ?", session[:current_user_id], Date.today.strftime('%Y%m%d') + ' 00:00:00', (Date.today + 1).strftime('%Y%m%d') + ' 00:00:00')
        #puts "hello world"
        #puts @usage
        render :text => @usage.to_json
    end

    def period
        @usage = Usage.where("feedId = ? and timestamp >= ? and timestamp < ?", session[:current_user_id], params['startdate'], params['enddate'])
        render :text => @usage.to_json
    end
end
