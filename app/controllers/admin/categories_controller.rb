class Admin::CategoriesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index; redirect_to :action => 'new' ; end

  def edit
    @categories = Category.find(:all)
    @category = Category.find(params[:id]) 
    @category.attributes = params[:category] 

    if request.post?
      respond_to do |format|
        format.html { save_category }
        format.js do 
          @category.save
          @article = Article.new
          @article.categories << @category
          return render(:partial => 'admin/content/categories')
        end
      end
    end
  end

  def new 
    @categories = Category.find(:all)

    respond_to do |format|
      format.html do
        process_new_category
      end
      format.js { 
        @category = Category.new
      }
    end
  end

  def destroy
    @record = Category.find(params[:id])
    return(render 'admin/shared/destroy') unless request.post?

    @record.destroy
    redirect_to :action => 'new'
  end

  private

  def process_new_category
    if request.post?
      respond_to do |format|
        format.html do
            if Category.create!(params[:category]) 
              flash[:notice] = _('Category was successfully created.')
              redirect_to :action => 'new'
            end
        end 
        format.js do 
          @category.save
          @article = Article.new
          @article.categories << @category
          return render(:partial => 'admin/content/categories')
        end
      end
    end
  end

  def save_category
    if @category.save!
      flash[:notice] = _('Category was successfully saved.')
    else
      flash[:error] = _('Category could not be saved.')
    end
    redirect_to :action => 'new'
  end

end
