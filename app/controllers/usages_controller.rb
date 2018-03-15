class UsagesController < ApplicationController
    def newest
        #@usage = Usage.all()
        #render plain:  @usage[@usage.size - 1].power
        usage = Usage.where("feedId = ?", session[:current_user_id]).last
        render plain:  usage.to_json
    end
    
    def newestday
        #puts Date.today.strftime('%Y%m%d')
        #puts (Date.today + 1).strftime('%Y%m%d')
        #@usage = Usage.where("timestamp >= '20170406 00:00:00' and timestamp < '20170407 00:00:00'")

        # Query last 12 hours records.  12 hours * 12 records per hour = 144 records.
        usage = Usage.where("feedId = ?", session[:current_user_id]).last(144)
        #puts "hello world"
        #puts @usage
        render plain:  usage.to_json
    end

    def dailyConsume
        #select strftime('%Y-%m-%d', timestamp), avg(power) from usages group by strftime('%Y-%m-%d', timestamp);
        # Return the power consume every day in unit of (kWh)
        usage = Usage.where("feedId = ?", session[:current_user_id]).select("date(timestamp) as date, sum(power) / 12 / 1000  as kwh").group("date(timestamp)");
        render plain:  usage.to_json
    end

    def weeklyConsume
        userInfo = User.where("feedId = ?", session[:current_user_id]).select("goal, groupNum, locale").limit(1);
        usage = Usage.where("feedId = ?", session[:current_user_id]).select("strftime('%W', timestamp) as week, sum(power) / 12 / 1000  as kwh").group("strftime('%W', timestamp)");
        render plain: {"goal":userInfo[0]["goal"], "groupNum":userInfo[0]["groupNum"], "locale":userInfo[0]["locale"], "usage":usage}.to_json
    end

    def last7days
        usage = Usage.where("feedId = ?", session[:current_user_id]).select("date(timestamp) as date, sum(power) / 12 / 1000  as kwh").group("date(timestamp)").last(7);
        render plain:  usage.to_json
    end

    # https://localhost/usages/peroid?startdate=&enddate=
    def peroid
        usage = Usage.where("feedId = ? and timestamp >= ? and timestamp < ?", session[:current_user_id], params['startdate'], params['enddate'])
        render plain:  usage.to_json
    end

    def hourAve
        usage = Usage.where("feedId = ?", session[:current_user_id]).select("strftime('%H', timestamp) as hour, sum(power) / 12 / 1000  as kwh").group("strftime('%H', timestamp)");
        render plain: usage.to_json

    end

    def allrecords
        power = Usage.where("feedId = ?", session[:current_user_id]).select("timestamp, power");
        usage = Usage.where("feedId = ?", session[:current_user_id]).select("date(timestamp) as date, sum(power) / 12 / 1000  as kwh").group("date(timestamp)");
        # TODO: NOT CORRECT!!! NEED to be changed when using non-fake data, here since the first data point is extremly large, we discard it.
        render plain: {"power":power[1..power.length], "usage":usage}.to_json
    end
end
