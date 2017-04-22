class UsagesController < ApplicationController
    def newest
        @usage = Usage.all()
        render :text => @usage[@usage.size - 1].power
    end
end
