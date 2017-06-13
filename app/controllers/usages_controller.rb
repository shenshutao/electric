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

        # Query last 12 hours records.  12 hours * 12 records per hour = 144 records.
        usage = Usage.where("feedId = ?", session[:current_user_id]).last(144)
        #puts "hello world"
        #puts @usage
        render :text => usage.to_json
    end

    def dailyConsume
        #select strftime('%Y-%m-%d', timestamp), avg(power) from usages group by strftime('%Y-%m-%d', timestamp);
        # Return the power consume every day in unit of (kWh)
        usage = Usage.where("feedId = ?", session[:current_user_id]).select("date(timestamp) as date, sum(power) / 12 / 1000  as kwh").group("date(timestamp)");
        render :text => usage.to_json
    end

    def weeklyConsume
        goal = User.where("feedId = ?", session[:current_user_id]).select("goal, groupNum");
        usage = Usage.where("feedId = ?", session[:current_user_id]).select("strftime('%W', timestamp) as week, sum(power) / 12 / 1000  as kwh").group("strftime('%W', timestamp)");
        render :text => {"goal":goal[0]["goal"], "groupNum":goal[0]["groupNum"],  "usage":usage}.to_json
    end

    def last7days
        usage = Usage.where("feedId = ?", session[:current_user_id]).select("date(timestamp) as date, sum(power) / 12 / 1000  as kwh").group("date(timestamp)").last(7);
        render :text => usage.to_json
    end

    # https://localhost/usages/peroid?startdate=&enddate=
    def peroid
        usage = Usage.where("feedId = ? and timestamp >= ? and timestamp < ?", session[:current_user_id], params['startdate'], params['enddate'])
        render :text => usage.to_json
    end
end
