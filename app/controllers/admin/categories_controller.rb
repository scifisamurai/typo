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
    @category = Category.new
    @categories = Category.find(:all)

    respond_to do |format|
      format.html #new.html.erb
      format.js { 
        @category = Category.new
      }
    end
  end

  def create
    @category = Category.new(params[:category])
    @categories = Category.find(:all)

    respond_to do |format|
      if @category.save(params[:category]) 
        format.html do
          flash[:notice] = _('Category was successfully created.')
          #redirect_to(@category, :notice => "Category was successfully created")
          redirect_to :action => "new"
        end 
        format.js do 
          @category.save
          @article = Article.new
          @article.categories << @category
          return render(:partial => 'admin/content/categories')
        end
      else
        format.html do
          render :action => "new"
        end
      end
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
