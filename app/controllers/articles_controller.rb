class ArticlesController < ApplicationController
    def show
        @article = Article.find(params[:id])
    end
    def new
    end

    def create
        #render plain: params[:article].inspect
        @article = Article.new(params[:article].permit(:title,:text))
        @article.save
        redirect_to @article
    end
end
